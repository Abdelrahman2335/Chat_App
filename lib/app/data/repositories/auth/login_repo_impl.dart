import 'dart:developer';

import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/auth/login_repo.dart';

class LoginRepoImpl implements LoginRepo {

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> createUser(String email, String password) async {
    try{
    await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }catch (error){
    log("cached error while creating user: $error");
    rethrow;
  }}

  @override
  Future<void> login(String email, String password) async {
    try {
      await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      log("cached error while logging in: $error");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseService.auth.signOut().onError((error, stackTrace) {
        log("Error while logging out: $error");
        return;
      });
    } catch (error) {
      log("cached error while logging out: $error");
      rethrow;
    }
  }
}


final loginRepoProvider = Provider<LoginRepo>((ref) {
  return LoginRepoImpl();
});
