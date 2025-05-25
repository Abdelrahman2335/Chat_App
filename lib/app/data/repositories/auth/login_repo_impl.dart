import 'dart:developer';

import 'package:chat_app/app/core/services/firebase_service.dart';

import '../../../domain/repositories/auth/login_repo.dart';

class LoginRepoImpl implements LoginRepo {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> createUser(String email, String password) async {
    await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> logout() async {}
}
