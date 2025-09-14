import 'dart:developer';

import 'package:chat_app/app/core/services/notification_helper.dart';
import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireDatabase {
  final FirebaseService _firebaseService = FirebaseService();
  final NotificationHelper _notificationHelper = NotificationHelper();

  final String myUid = FirebaseService().auth.currentUser!.uid;
  final String now = DateTime.now().millisecondsSinceEpoch.toString();

  /// Send notification when a new message is sent
  Future<void> sendNotification({
    required UserModel chatUser,
    required BuildContext context,
    required String msg,
    required String roomId,
    String? messageType = 'text',
  }) async {
    try {
      // Get current user data
      final currentUserDoc =
          await _firebaseService.firestore.collection("users").doc(myUid).get();

      if (!currentUserDoc.exists) {
        log('Current user not found');
        return;
      }

      final currentUserData = currentUserDoc.data()!;
      final senderName = currentUserData['name'] as String? ?? 'Unknown';

      // Send notification
      final result = await _notificationHelper.sendMessageNotification(
        receiverId: chatUser.id!,
        senderName: senderName,
        messageContent: msg,
        roomId: roomId,
        senderId: myUid,
      );

      result.fold(
        (failure) =>
            log('Failed to send notification: ${failure.errorMessage}'),
        (_) => log('Notification sent successfully'),
      );
    } catch (e) {
      log('Error in sendNotification: $e');
    }
  }

  /// Send notification for group messages
  Future<void> sendGroupNotification({
    required String groupId,
    required String msg,
    required String groupName,
    String? messageType = 'text',
  }) async {
    try {
      // Get current user data
      final currentUserDoc =
          await _firebaseService.firestore.collection("users").doc(myUid).get();

      if (!currentUserDoc.exists) {
        log('Current user not found');
        return;
      }

      final currentUserData = currentUserDoc.data()!;
      final senderName = currentUserData['name'] as String? ?? 'Unknown';

      // Send group notification
      final result = await _notificationHelper.sendGroupMessageNotification(
        groupId: groupId,
        senderName: senderName,
        messageContent: msg,
        groupName: groupName,
        senderId: myUid,
      );

      result.fold(
        (failure) =>
            log('Failed to send group notification: ${failure.errorMessage}'),
        (_) => log('Group notification sent successfully'),
      );
    } catch (e) {
      log('Error in sendGroupNotification: $e');
    }
  }

  /// Send notification when user is added to group
  Future<void> sendGroupInviteNotification({
    required String newMemberId,
    required String groupName,
    required String groupId,
  }) async {
    try {
      // Get current user data
      final currentUserDoc =
          await _firebaseService.firestore.collection("users").doc(myUid).get();

      if (!currentUserDoc.exists) {
        log('Current user not found');
        return;
      }

      final currentUserData = currentUserDoc.data()!;
      final inviterName = currentUserData['name'] as String? ?? 'Someone';

      // Send invite notification
      final result = await _notificationHelper.sendGroupInviteNotification(
        newMemberId: newMemberId,
        groupName: groupName,
        inviterName: inviterName,
        groupId: groupId,
      );

      result.fold(
        (failure) =>
            log('Failed to send invite notification: ${failure.errorMessage}'),
        (_) => log('Invite notification sent successfully'),
      );
    } catch (e) {
      log('Error in sendGroupInviteNotification: $e');
    }
  }

  /// Initialize notification system
  Future<void> initializeNotifications() async {
    await _notificationHelper.initialize();
  }

  /// Get current user's FCM token
  Future<String?> getCurrentUserFCMToken() async {
    return await _notificationHelper.getCurrentUserToken();
  }

  // ... rest of your existing methods remain the same

  Future editProfile(String name, String about) async {
    await _firebaseService.firestore
        .collection("users")
        .doc(myUid)
        .update({"name": name, "about": about});
  }

  Future editGroup(String gId, String name, List members) async {
    await _firebaseService.firestore
        .collection("groups")
        .doc(gId)
        .update({"name": name, "members": FieldValue.arrayUnion(members)});

    // Send invite notifications to new members
    for (final memberId in members) {
      if (memberId != myUid) {
        // Don't notify yourself
        await sendGroupInviteNotification(
          newMemberId: memberId,
          groupName: name,
          groupId: gId,
        );
      }
    }
  }

  Future removeMember(String gId, memberId) async {
    await _firebaseService.firestore.collection("groups").doc(gId).update({
      "members": FieldValue.arrayRemove([memberId])
    });
  }

  Future promptAdmin(String gId, memberId) async {
    await _firebaseService.firestore.collection("groups").doc(gId).update({
      "admin": FieldValue.arrayUnion([memberId])
    });
  }

  Future removeAdmin(String gId, memberId) async {
    await _firebaseService.firestore.collection("groups").doc(gId).update({
      "admin": FieldValue.arrayRemove([memberId])
    });
  }
}
