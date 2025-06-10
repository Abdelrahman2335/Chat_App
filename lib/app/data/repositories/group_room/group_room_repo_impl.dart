import 'dart:developer';
import 'dart:io';

import 'package:chat_app/app/data/models/message_model.dart';
import 'package:chat_app/app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';
import '../../../domain/repositories/group/group_room_repo.dart';

class GroupRoomRepoImpl implements GroupRoomRepo {
  final FirebaseService _firebaseService = FirebaseService();
  final dateTime = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Stream<List<Message>> getGroupMessages(String groupId) {
    try {
      if (groupId.isEmpty) {
        log("[getGroupMessages] Skipped: empty groupId");
        return const Stream.empty();
      }

      return _firebaseService.firestore
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Message.fromJson(doc.data()))
            .toList();
      });
    } catch (error) {
      log("[getGroupMessages] Error: $error");
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getGroupMembers(List members) async {
    try {
      if (members.isEmpty) return [];

      // Remove duplicates - simple fix to avoid fetching same user twice
      final uniqueMembers = members.toSet().toList();

      final List<Future<List<UserModel>>> batchFutures = [];

      for (int i = 0; i < uniqueMembers.length; i += 10) {
        final batch = uniqueMembers
            .skip(i)
            .take(10)
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList();

        if (batch.isNotEmpty) {
          batchFutures.add(_fetchUserBatch(batch));
        }
      }

      final results = await Future.wait(batchFutures);
      return results.expand((batch) => batch).toList();
    } catch (error) {
      log("[getGroupMembers] Error: $error");
      rethrow;
    }
  }

  Future<List<UserModel>> _fetchUserBatch(List ids) async {
    final snapshot = await _firebaseService.firestore
        .collection("users")
        .where("id", whereIn: ids)
        .get();
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> sendGroupMessage(Message message, String groupId) async {
    try {
      if (groupId.isEmpty ||
          message.msg == null ||
          message.msg!.trim().isEmpty) {
        log("[sendGMessage] Skipped: empty groupId or message");
        log("groupId: $groupId");
        log("message: ${message.msg}");
        return;
      }

      message.fromId ??= _firebaseService.auth.currentUser!.uid;

      message.createdAt ??= DateTime.now().millisecondsSinceEpoch.toString();
      await _firebaseService.firestore
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .doc(message.id)
          .set(message.toJson());

      await _firebaseService.firestore
          .collection("groups")
          .doc(groupId)
          .update({
        "lastMessage": message.type ?? message.msg,
        "lastMessageTime": dateTime
      });
    } catch (error) {
      log("[sendGMessage] Error: $error");
      rethrow;
    }
  }

  @override
  Future<void> sendGroupImage(
      File file, String groupId, String? currentId, String toId) async {
    currentId ??= _firebaseService.auth.currentUser!.uid;
    try {
      String ext = file.path.split(".").last;

      /// reference in Flutter is used to store things like images in specific locations in the Firebase Storage
      final ref = _firebaseService.fireStorage
          .ref()
          .child("images/$groupId/$dateTime.$ext");

      ///here we are taking the file and uploading it to the firestore in the ref location that he told us about.
      await ref.putFile(file);

      ///this line knows where is the file is stored so we can use it later in any part of the project
      String imageUrl = await ref.getDownloadURL();

      await sendGroupMessage(
          Message(
              msg: imageUrl,
              type: "image",
              toId: toId,
              // we can don't need this, but check it later
              fromId: currentId,
              createdAt: dateTime,
              read: ''),
          groupId);
    } catch (error) {
      log("Error in the chat room Impl while sending image: $error");
    }
  }
}

Provider<GroupRoomRepo> groupRoomRepoProvider =
    Provider((ref) => GroupRoomRepoImpl());
