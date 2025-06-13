import 'dart:developer';
import 'dart:io';

import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/data/models/message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/repositories/chat/chat_room_repo.dart';

part 'chat_room_repo_impl.g.dart';

class ChatRoomImpl implements ChatRoomRepo {
  final FirebaseService _firebaseService = FirebaseService();
  final dateTime = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Stream<List<Message>> getMessages(String roomId) {
    try {
      return _firebaseService.firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .snapshots()
          .map((event) {
        final message =
        event.docs.map((msg) => Message.fromJson(msg.data())).toList();
        return message;
      }
      );


    } catch (error) {
      log("Error in the chat room Impl while getting messages: $error");
      rethrow;
    }

  }

  @override
  Future<void> sendMessage(Message message, String roomId) async {
    message.fromId ??= _firebaseService.auth.currentUser!.uid;
    message.senderName ??= _firebaseService.auth.currentUser!.displayName;
    try {
      await _firebaseService.firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .doc(message.id)
          .set(
            message.toJson(),
          );

      await _firebaseService.firestore.collection("rooms").doc(roomId).update({
        "lastMessage": message.type == "image" ? "image" : message.msg,
        "lastMessageTime": dateTime
      });
    } catch (error) {
      log("Error in the chat room Impl: $error");
      rethrow;
    }
  }

  @override
  Future<void> sendImage(
      File file, String roomId, String? currentId, String toId) async {
    currentId ??= _firebaseService.auth.currentUser!.uid;
    try {
      String ext = file.path.split(".").last;

      /// reference in Flutter is used to store things like images in specific locations in the Firebase Storage
      final ref = _firebaseService.fireStorage.ref().child(
          "images/$roomId/$dateTime.$ext");

      ///here we are taking the file and uploading it to the firestore in the ref location that he told us about.
      await ref.putFile(file);

      ///this line knows where is the file is stored so we can use it later in any part of the project
      String imageUrl = await ref.getDownloadURL();

      await sendMessage(
          Message(msg: imageUrl,
              senderName: _firebaseService.auth.currentUser!.displayName!,
              type: "image",
              toId: toId, // we can don't need this, but check it later
              fromId: currentId, createdAt: dateTime, read: ''),
          roomId);
    } catch (error) {
      log("Error in the chat room Impl while sending image: $error");
    }
  }

  @override
  Future<void> readMessage(String roomId, List<Message> messages) async {
    if (messages.isEmpty) return;

    final msgIds = messages
        .where((e) => e.toId == _firebaseService.auth.currentUser!.uid)
        .map((e) => e.id)
        .toList();    try {
      final batch = _firebaseService.firestore.batch();
      final messagesRef = _firebaseService.firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages");

      for (final msgId in msgIds) {
        batch.update(messagesRef.doc(msgId), {"read": dateTime});
      }

      await batch.commit();
    } catch (error) {
      log("[readMessage] Error: $error");
      rethrow;
    }
  }

  @override
  Future<void> deleteMsg(String roomId, List<String> msgIds) async {
    if (msgIds.isEmpty) return;
    log("Room id: $roomId");
    log("Message id: $msgIds");
    try {
      final batch = _firebaseService.firestore.batch();
      final messagesRef = _firebaseService.firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages");

      for (final msgId in msgIds) {
        batch.delete(messagesRef.doc(msgId));
      }

      await batch.commit();
    } catch (error) {
      log("[deleteMsg] Error: $error");
      rethrow;
    }
  }
}

@riverpod
ChatRoomRepo chatRoomRepo(ref) {
  return ChatRoomImpl();
}
