import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/app/core/errors/dio_failure.dart';
import 'package:chat_app/app/core/errors/failure.dart';
import 'package:chat_app/app/core/models/notification_model.dart';
import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/core/utils/api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseNotification {
  static final FirebaseNotification _instance =
      FirebaseNotification._internal();
  factory FirebaseNotification() => _instance;
  FirebaseNotification._internal();

  final FirebaseService _firebaseService = FirebaseService();
  String? _cachedAccessToken;
  DateTime? _tokenExpiryTime;

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    try {
      // Request notification permissions
      NotificationSettings settings =
          await _firebaseService.firebaseMessaging.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('FCM: User granted permission');

        // Get and store FCM token
        await _updateFCMToken();

        // Setup message handlers
        _setupMessageHandlers();
      } else {
        log('FCM: User declined or has not accepted permission');
      }
    } catch (e) {
      log('FCM initialization error: $e');
    }
  }

  /// Get FCM token and update in Firestore
  Future<void> _updateFCMToken() async {
    try {
      if (_firebaseService.auth.currentUser != null) {
        final token = await _firebaseService.firebaseMessaging.getToken();
        if (token != null) {
          // Update user's FCM token in Firestore
          await _firebaseService.firestore
              .collection("users")
              .doc(_firebaseService.auth.currentUser?.uid)
              .update({"push_token": token});

          log('FCM Token updated: ${token.substring(0, 20)}...');
        }
      }
    } catch (e) {
      log('Error updating FCM token: $e');
    }
  }

  /// Setup foreground and background message handlers
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received foreground message: ${message.notification?.title}');
      _handleMessage(message);
    });
    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Message clicked: ${message.notification?.title}');
      _handleNotificationTap(message);
    });
  }

  /// Handle incoming message
  void _handleMessage(
    RemoteMessage message,
  ) {
    // Add your custom logic here
    // e.g., show local notification, update UI, etc.
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    // Add navigation logic here
    // e.g., navigate to specific chat room
    final data = message.data;
    if (data.containsKey('roomId')) {
      // Navigate to chat room
      log('Navigating to room: ${data['roomId']}');
    }
  }

  /// Get OAuth 2.0 access token for FCM HTTP v1 API
  Future<Either<Failure, String>> getAccessToken() async {
    try {
      if (_cachedAccessToken != null &&
          _tokenExpiryTime != null &&
          DateTime.now().isBefore(_tokenExpiryTime!)) {
        return Right(_cachedAccessToken!);
      }

      // Load service account credentials from assets
      final credentialsJson = await _loadServiceAccountCredentials();
      final credentials =
          ServiceAccountCredentials.fromJson(jsonDecode(credentialsJson));

      // The scope required for FCM
      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      // Get authenticated client
      final client = await clientViaServiceAccount(credentials, scopes);

      // Cache the token with expiry time (usually 1 hour)
      _cachedAccessToken = client.credentials.accessToken.data;
      _tokenExpiryTime = client.credentials.accessToken.expiry;

      client.close();

      return Right(_cachedAccessToken!);
    } catch (e) {
      log('Error getting access token: $e');
      return Left(ServerFailure('Failed to get access token: $e'));
    }
  }

  /// Load service account credentials from assets (secure way)
  Future<String> _loadServiceAccountCredentials() async {
    try {
      return await rootBundle.loadString('assets/config/service-account.json');
    } catch (e) {
      // Fallback to environment variable or secure storage
      throw Exception('Service account credentials not found. '
          'Please add service-account.json to assets/config/');
    }
  }

  /// Send notification to specific user
  Future<Either<Failure, void>> sendNotification(
      {required NotificationModel notificationModel}) async {
    try {
      // Get access token
      final tokenResult = await getAccessToken();
      if (tokenResult.isLeft()) {
        return Left((tokenResult as Left).value);
      }

      final accessToken = (tokenResult as Right).value;

      // Prepare notification payload
      final notificationPayload = {
        "message": {
          "token": notificationModel.token,
          "notification": {
            "title": notificationModel.title,
            "body": notificationModel.body,
          },
          "data": {
            if (notificationModel.roomId != null)
              "roomId": notificationModel.roomId,
            if (notificationModel.senderId != null)
              "senderId": notificationModel.senderId,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          },
          "android": {
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "chat_messages",
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "category": "CHAT_MESSAGE",
                "sound": "default",
              }
            }
          }
        }
      };

      // Send notification
      final response = await ApiService.instance.post(
        accessToken: accessToken,
        body: notificationPayload,
      );

      log('Notification sent successfully: $response');
      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        log('Error sending notification Dio exception: ${ServerFailure.fromDioException(error).errorMessage}');
        return Left(ServerFailure.fromDioException(error));
      } else {
        log('Error sending notification: ${ServerFailure(error.toString())}');
        return Left(ServerFailure(error.toString()));
      }
    }
  }

  /// Send notification to multiple users
  Future<Either<Failure, void>> sendMulticastNotification({
    required NotificationModel notificationModel,
    required List<String> deviceTokens,
  }) async {
    try {
      if (deviceTokens.isEmpty) {
        return Left(ServerFailure('No device tokens provided'));
      }

      // Split tokens into chunks of 500 (FCM limit)
      const chunkSize = 500;
      final chunks = <List<String>>[];
      for (int i = 0; i < deviceTokens.length; i += chunkSize) {
        chunks.add(deviceTokens.sublist(
            i,
            i + chunkSize > deviceTokens.length
                ? deviceTokens.length
                : i + chunkSize));
      }

      // Send to each chunk
      for (final chunk in chunks) {
        final result = await _sendToTokenChunk(
          notificationModel: notificationModel,
          tokens: chunk,
        );

        if (result.isLeft()) {
          return result;
        }
      }

      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  /// Send notification to a chunk of tokens
  Future<Either<Failure, void>> _sendToTokenChunk({
    required NotificationModel notificationModel,
    required List<String> tokens,
  }) async {
    try {
      final tokenResult = await getAccessToken();
      if (tokenResult.isLeft()) {
        return Left((tokenResult as Left).value);
      }

      final accessToken = (tokenResult as Right).value;

      final notificationPayload = {
        "message": {
          "tokens": tokens,
          "notification": {
            "title": notificationModel.title,
            "body": notificationModel.body,
          },
          "data": {
            if (notificationModel.roomId != null)
              "roomId": notificationModel.roomId,
            if (notificationModel.senderId != null)
              "senderId": notificationModel.senderId,
            if (notificationModel.data != null)
              ...notificationModel.data!
                  .map((key, value) => MapEntry(key, value.toString())),
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          },
          "android": {
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": "chat_messages",
              "priority": "high",
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "category": "CHAT_MESSAGE",
                "sound": "default",
              }
            }
          }
        }
      };

      await ApiService.instance.post(
        accessToken: accessToken,
        body: notificationPayload,
      );

      return const Right(null);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      } else {
        return Left(ServerFailure(error.toString()));
      }
    }
  }

  /// Get user's FCM token
  Future<String?> getUserFCMToken() async {
    try {
      return await _firebaseService.firebaseMessaging.getToken();
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseService.firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) {
      log('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseService.firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) {
      log('Error unsubscribing from topic: $e');
    }
  }

  /// Clear cached access token (useful for testing)
  void clearCachedToken() {
    _cachedAccessToken = null;
    _tokenExpiryTime = null;
  }
}
