import 'dart:developer';

import 'package:chat_app/app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_service.dart';
import '../../../domain/repositories/contact/contact_home_repo.dart';

class ContactHomeRepoImpl implements ContactHomeRepo {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> addContact(String email) async {
    {
      try {
        final userEmail = await _firebaseService.firestore
            .collection("users")
            .where("email", isEqualTo: email)
            .get();
        log(userEmail.docs.isNotEmpty.toString());
        log(email);
        if (userEmail.docs.isNotEmpty) {
          log("${userEmail.docs.isNotEmpty}");
          String userId = userEmail.docs.first.id;
          await _firebaseService.firestore
              .collection("users")
              .doc(_firebaseService.auth.currentUser!.uid)
              .update({
            "my_users": FieldValue.arrayUnion([userId])
          });
        }
      } catch (e) {
        log("Error in the addContact method $e");
        rethrow;
      }
    }
  }

  @override
  Future<List<UserModel>> getContacts() async {
    final currentUser = _firebaseService.auth.currentUser!.uid;
    try {
      final data = await _firebaseService.firestore
          .collection("users")
          .doc(currentUser)
          .get();

      List<String> userContacts =
          List<String>.from(data.data()?["my_users"] ?? []);

      if (userContacts.isEmpty) {
        return [];
      }

      // Handle large contact lists by chunking into groups of 10
      List<UserModel> allContacts = [];

      for (int i = 0; i < userContacts.length; i += 10) {
        final chunk = userContacts.skip(i).take(10).toList();
        final cleanedChunk = chunk.where((id) => id.trim().isNotEmpty).toList();

        if (cleanedChunk.isEmpty) {
          log("Skipping empty or invalid chunk at index $i");
          continue;
        }

        log("Fetching chunk: $cleanedChunk");

        final contactUsers = await _firebaseService.firestore
            .collection("users")
            .where(FieldPath.documentId, whereIn: cleanedChunk)
            .get();

        allContacts.addAll(
            contactUsers.docs.map((doc) => UserModel.fromJson(doc.data())).toList()
        );
      }

      return allContacts;
    } catch (e) {
      log("Error in the getContacts method: $e");
      rethrow;
    }
  }
}

Provider<ContactHomeRepoImpl> contactHomeRepoProvider =
    Provider((ref) => ContactHomeRepoImpl());
