import 'dart:developer';

import 'package:chat_app/app/core/models/notification_model.dart';
import 'package:chat_app/app/core/services/firebase_notification.dart';
import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:dartz/dartz.dart';

import '../errors/failure.dart';
import '../errors/dio_failure.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FirebaseNotification _notificationService = FirebaseNotification();
  final FirebaseService _firebaseService = FirebaseService();

  /// Send notification when a new message is sent
  Future<Either<Failure, void>> sendMessageNotification({
    required String receiverId,
    required String senderName,
    required String messageContent,
    required String roomId,
    String? senderId,
  }) async {
    try {
      // Get receiver's FCM token
      final receiverDoc = await _firebaseService.firestore
          .collection("users")
          .doc(receiverId)
          .get();

      if (!receiverDoc.exists) {
        return Left(ServerFailure('Receiver not found'));
      }

      final receiverData = receiverDoc.data()!;
      final fcmToken = receiverData['push_token'] as String?;

      if (fcmToken == null || fcmToken.isEmpty) {
        log('No FCM token found for user: $receiverId');
        return const Right(
            null); // Not an error, user might not have notifications enabled
      }

      // Check if receiver is online (optional - don't send if online)
      final isOnline = receiverData['online'] as bool? ?? false;
      if (isOnline) {
        log('User is online, skipping notification');
        return const Right(null);
      }

      // Create notification model
      final notificationModel = _createMessageNotification(
        title: senderName,
        messageContent: messageContent,
        token: fcmToken,
        roomId: roomId,
        senderId: senderId,
      );

      return await _notificationService.sendNotification(
        notificationModel: notificationModel,
      );
    } catch (e) {
      log('Error sending message notification: $e');
      return Left(ServerFailure('Failed to send notification: $e'));
    }
  }

  /// Send notification to group members when a new group message is sent
  Future<Either<Failure, void>> sendGroupMessageNotification({
    required String groupId,
    required String senderName,
    required String messageContent,
    required String groupName,
    String? senderId,
  }) async {
    try {
      // Get group data
      final groupDoc = await _firebaseService.firestore
          .collection("groups")
          .doc(groupId)
          .get();

      if (!groupDoc.exists) {
        return Left(ServerFailure('Group not found'));
      }

      final groupData = groupDoc.data()!;
      final members = List<String>.from(groupData['members'] ?? []);

      // Remove sender from notification list
      if (senderId != null) {
        members.remove(senderId);
      }

      if (members.isEmpty) {
        return const Right(null);
      }

      // Get FCM tokens for all members
      final memberTokens = <String>[];

      // Batch get user data
      final userDocs = await _firebaseService.firestore
          .collection("users")
          .where("id", whereIn: members)
          .get();

      for (final doc in userDocs.docs) {
        final userData = doc.data();
        final isOnline = userData['online'] as bool? ?? false;
        final fcmToken = userData['push_token'] as String?;

        // Only add token if user is offline and has a token
        if (!isOnline && fcmToken != null && fcmToken.isNotEmpty) {
          memberTokens.add(fcmToken);
        }
      }

      if (memberTokens.isEmpty) {
        return const Right(null);
      }

      // Create notification model
      final notificationModel = _createGroupNotification(
        title: '$senderName • $groupName',
        messageContent: messageContent,
        token: '', // Will be replaced by individual tokens
        roomId: groupId,
        senderId: senderId,
        additionalData: {
          'type': 'group_message',
          'groupName': groupName,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      // Send multicast notification
      return await _notificationService.sendMulticastNotification(
        notificationModel: notificationModel,
        deviceTokens: memberTokens,
      );
    } catch (e) {
      log('Error sending group notification: $e');
      return Left(ServerFailure('Failed to send group notification: $e'));
    }
  }

  /// Send notification when user is added to a group
  Future<Either<Failure, void>> sendGroupInviteNotification({
    required String newMemberId,
    required String groupName,
    required String inviterName,
    required String groupId,
  }) async {
    try {
      // Get new member's FCM token
      final memberDoc = await _firebaseService.firestore
          .collection("users")
          .doc(newMemberId)
          .get();

      if (!memberDoc.exists) {
        return Left(ServerFailure('Member not found'));
      }

      final memberData = memberDoc.data()!;
      final fcmToken = memberData['push_token'] as String?;

      if (fcmToken == null || fcmToken.isEmpty) {
        return const Right(null);
      }

      final NotificationModel notificationModel =
          _createGroupInviteNotification(
        groupName: groupName,
        inviterName: inviterName,
        token: fcmToken,
        roomId: groupId,
      );

      return await _notificationService.sendNotification(
        notificationModel: notificationModel,
      );
    } catch (e) {
      log('Error sending group invite notification: $e');
      return Left(
          ServerFailure('Failed to send group invite notification: $e'));
    }
  }

  /// Initialize notification service
  Future<void> initialize() async {
    await _notificationService.initialize();
  }

  /// Get current user's FCM token
  Future<String?> getCurrentUserToken() async {
    return await _notificationService.getUserFCMToken();
  }

  /// Helper method to create message notification model
  NotificationModel _createMessageNotification({
    required String title,
    required String messageContent,
    required String token,
    String? roomId,
    String? senderId,
    Map<String, dynamic>? additionalData,
  }) {
    String notificationBody = messageContent;
    if (messageContent.startsWith('http')) {
      notificationBody = '📷 Image';
    } else if (messageContent.length > 50) {
      notificationBody = '${messageContent.substring(0, 50)}...';
    }

    return NotificationModel(
      title: title,
      body: notificationBody,
      type: NotificationType.message,
      token: token,
      roomId: roomId,
      senderId: senderId,
      data: additionalData,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Helper method to create group notification model
  NotificationModel _createGroupNotification({
    required String title,
    required String messageContent,
    required String token,
    String? roomId,
    String? senderId,
    Map<String, dynamic>? additionalData,
  }) {
    String notificationBody = messageContent;
    if (messageContent.startsWith('http')) {
      notificationBody = '📷 Image';
    } else if (messageContent.length > 50) {
      notificationBody = '${messageContent.substring(0, 50)}...';
    }

    return NotificationModel(
      title: title,
      body: notificationBody,
      type: NotificationType.message,
      token: token,
      roomId: roomId,
      senderId: senderId,
      data: additionalData,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Helper method to create group invite notification model
  NotificationModel _createGroupInviteNotification({
    required String groupName,
    required String inviterName,
    required String token,
    String? roomId,
  }) {
    return NotificationModel(
      title: 'Added to Group',
      body: '$inviterName added you to "$groupName"',
      type: NotificationType.groupInvite,
      token: token,
      roomId: roomId,
      data: {
        'type': 'group_invite',
        'groupName': groupName,
        'inviterName': inviterName,
      },
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }
}
