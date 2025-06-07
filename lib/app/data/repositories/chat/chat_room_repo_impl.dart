import 'dart:developer';
import 'dart:io';

import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/data/models/message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/repositories/chat_room/chat_room_repo.dart';

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
        "lastMessage": message.type ?? message.msg,
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
              type: "image",
              toId: toId,
              fromId: currentId, createdAt: dateTime, read: ''),
          roomId);
    } catch (error) {
      log("Error in the chat room Impl while sending image: $error");
    }
  }
}

@riverpod
ChatRoomRepo chatRoomRepo(ref) {
  return ChatRoomImpl();
}
