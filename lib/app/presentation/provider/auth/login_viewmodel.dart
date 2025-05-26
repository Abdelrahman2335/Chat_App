import 'dart:developer';

import 'package:chat_app/app/domain/repositories/auth/login_repo.dart';

class LoginViewModel {
  final LoginRepo _loginRepo;

  LoginViewModel(this._loginRepo);

  Future<void> createUser(String email, String password) async {
    /// Add loading state
    try {
      await _loginRepo.createUser(email, password);
    } catch (error) {
      log("cached error while creating user viewmodel: $error");
    }
  }

  Future<void> login(String email, String password) async {
    /// Add loading state
    try {
      await _loginRepo.login(email, password);
    } catch (error) {
      log("cached error while logging in viewmodel: $error");
    }
  }

  Future<void> logout() async {
    /// Add loading state
    try {
      await _loginRepo.logout();
    } catch (error) {
      log("cached error while logging out viewmodel: $error");
    }
  }
}
