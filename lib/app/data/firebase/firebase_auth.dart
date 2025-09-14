import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/core/services/firebase_notification.dart';

import '../models/user_model.dart';

class FireAuth {
  static final FireAuth _instance = FireAuth._internal();
  factory FireAuth() => _instance;
  FireAuth._internal();

  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseNotification _notificationService = FirebaseNotification();

  User? get currentUser => _firebaseService.auth.currentUser;

  /// Create user profile in Firestore
  Future<bool> createUser() async {
    try {
      final user = currentUser;
      if (user == null) {
        log('No authenticated user found');
        return false;
      }

      // Initialize notification service first
      await _notificationService.initialize();

      // Get FCM token
      final fcmToken = await _notificationService.getUserFCMToken();

      UserModel chatUser = UserModel(
        id: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        about: "Hi I'm ${user.displayName ?? 'there'}",
        image: user.photoURL ?? "",
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        lastSeen: DateTime.now().millisecondsSinceEpoch.toString(),
        pushToken: fcmToken ?? "", // Use the actual FCM token
        online: true, // User is online when creating account
        myUsers: [],
      );

      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .set(chatUser.toJson());

      log('User profile created successfully with FCM token');
      return true;
    } catch (e) {
      log('Error creating user: $e');
      return false;
    }
  }

  /// Update user's FCM token in Firestore
  Future<bool> updateToken() async {
    try {
      final user = currentUser;
      if (user == null) {
        log('No authenticated user found');
        return false;
      }

      // Get fresh FCM token
      final token = await _notificationService.getUserFCMToken();
      if (token == null || token.isEmpty) {
        log('No FCM token available');
        return false;
      }

      // Update in Firestore using consistent field name
      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .update({
        "push_token": token
      }); // Keep consistent with UserModel JSON serialization

      log('FCM token updated successfully');
      return true;
    } catch (e) {
      log('Error updating FCM token: $e');
      return false;
    }
  }

  /// Update user's FCM token with a specific token value
  Future<bool> updateTokenWithValue(String token) async {
    try {
      final user = currentUser;
      if (user == null) {
        log('No authenticated user found');
        return false;
      }

      if (token.isEmpty) {
        log('Empty token provided');
        return false;
      }

      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .update({"push_token": token});

      log('FCM token updated with provided value');
      return true;
    } catch (e) {
      log('Error updating FCM token with value: $e');
      return false;
    }
  }

  /// Update user's online status
  Future<bool> updateStatus(bool status) async {
    try {
      final user = currentUser;
      if (user == null) {
        log('No authenticated user found');
        return false;
      }

      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .update({
        "online": status,
        "last_seen": DateTime.now().millisecondsSinceEpoch.toString(),
      });

      log('User status updated to: ${status ? "online" : "offline"}');
      return true;
    } catch (e) {
      log('Error updating user status: $e');
      return false;
    }
  }

  /// Update user profile information
  Future<bool> updateProfile({
    String? name,
    String? about,
    String? imageUrl,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        log('No authenticated user found');
        return false;
      }

      Map<String, dynamic> updates = {};

      if (name != null && name.isNotEmpty) {
        updates["name"] = name;
      }

      if (about != null && about.isNotEmpty) {
        updates["about"] = about;
      }

      if (imageUrl != null && imageUrl.isNotEmpty) {
        updates["image"] = imageUrl;
      }

      if (updates.isEmpty) {
        log('No updates provided');
        return false;
      }

      await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .update(updates);

      log('User profile updated successfully');
      return true;
    } catch (e) {
      log('Error updating user profile: $e');
      return false;
    }
  }

  /// Get current user's data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = currentUser;
      if (user == null) {
        log('No authenticated user found');
        return null;
      }

      final doc = await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        log('User document not found');
        return null;
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      log('Error getting user data: $e');
      return null;
    }
  }

  /// Check if user document exists
  Future<bool> userExists() async {
    try {
      final user = currentUser;
      if (user == null) return false;

      final doc = await _firebaseService.firestore
          .collection("users")
          .doc(user.uid)
          .get();

      return doc.exists;
    } catch (e) {
      log('Error checking user existence: $e');
      return false;
    }
  }

  /// Initialize user session (call after login)
  Future<void> initializeUserSession() async {
    try {
      // Set user as online
      await updateStatus(true);

      // Update/refresh FCM token
      await updateToken();

      log('User session initialized');
    } catch (e) {
      log('Error initializing user session: $e');
    }
  }

  /// Cleanup user session (call before logout)
  Future<void> cleanupUserSession() async {
    try {
      // Set user as offline
      await updateStatus(false);

      log('User session cleaned up');
    } catch (e) {
      log('Error cleaning up user session: $e');
    }
  }

  /// Sign out user
  Future<bool> signOut() async {
    try {
      // Cleanup session first
      await cleanupUserSession();

      // Sign out from Firebase Auth
      await _firebaseService.auth.signOut();

      log('User signed out successfully');
      return true;
    } catch (e) {
      log('Error signing out: $e');
      return false;
    }
  }
}
