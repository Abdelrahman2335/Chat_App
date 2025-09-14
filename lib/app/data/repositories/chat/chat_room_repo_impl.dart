import 'dart:developer';
import 'dart:io';

import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/core/services/notification_helper.dart';
import 'package:chat_app/app/data/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/repositories/chat/chat_room_repo.dart';

part 'chat_room_repo_impl.g.dart';

final notification = NotificationHelper();

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
        final messages =
            event.docs.map((msg) => Message.fromJson(msg.data())).toList();

        return messages;
      });
    } catch (error) {
      log("Error in the chat room Impl while getting messages: $error");
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(Message message, String roomId) async {
    // Ensure sender fields are populated if missing
    message.senderId =
        message.senderId ?? _firebaseService.auth.currentUser?.uid;
    message.senderName =
        message.senderName ?? _firebaseService.auth.currentUser?.displayName;
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
        "lastMessage":
            message.type == "image" ? "image" : message.messageContent,
        "lastMessageTime": dateTime
      });

      final currentUid = _firebaseService.auth.currentUser?.uid;
      final receiverId = message.receiverId;
      final senderName = message.senderName ?? 'Someone';
      final content =
          message.type == 'image' ? 'image' : message.messageContent;

      if (currentUid != null &&
          message.senderId == currentUid &&
          receiverId != null &&
          content.isNotEmpty) {
        try {
          await notification.sendMessageNotification(
            receiverId: receiverId,
            senderName: senderName,
            messageContent: content,
            roomId: roomId,
            senderId: currentUid,
          );
        } catch (e) {
          // Do not fail message send if notification fails
          log('[sendMessage] Notification send failed: $e');
        }
      }
    } catch (error) {
      log("Error in the chat room Impl: $error");
      rethrow;
    }
  }

  @override
  Future<void> sendImage(
      File file, String roomId, String? currentId, String receiverId) async {
    currentId ??= _firebaseService.auth.currentUser!.uid;
    try {
      String ext = file.path.split(".").last;

      final ref = _firebaseService.fireStorage
          .ref()
          .child("images/$roomId/$dateTime.$ext");

      ///here we are taking the file and uploading it to the firestore in the ref location that he told us about.
      await ref.putFile(file);

      ///this line knows where is the file is stored so we can use it later in any part of the project
      String imageUrl = await ref.getDownloadURL();

      await sendMessage(
          Message(
            messageContent: imageUrl,
            senderName: _firebaseService.auth.currentUser!.displayName!,
            type: "image",
            receiverId: receiverId,
            senderId: currentId,
            createdAt: dateTime,
            read: '',
          ),
          roomId);
    } catch (error) {
      log("Error in the chat room Impl while sending image: $error");
    }
  }

  @override
  Future<void> readMessage(String roomId, List<Message> messages) async {
    if (messages.isEmpty) return;

    // Ensure a signed-in user exists before proceeding
    final uid = _firebaseService.auth.currentUser?.uid;
    if (uid == null) {
      log("[readMessage] Skipping mark-as-read: currentUser is null");
      return;
    }

    final msgIds = messages
        .where((e) => e.receiverId == uid && e.id != null)
        .map((e) => e.id!)
        .toList();
    try {
      final batch = _firebaseService.firestore.batch();
      final messagesRef = _firebaseService.firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages");

      if (msgIds.isEmpty) {
        return;
      }

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
  Future<void> deleteMessage(String roomId, List<String> msgIds) async {
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
ChatRoomRepo chatRoomRepo(Ref ref) {
  return ChatRoomImpl();
}
