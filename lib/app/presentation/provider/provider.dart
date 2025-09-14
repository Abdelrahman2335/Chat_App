import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/firebase/firebase_auth.dart';
import '../../data/models/user_model.dart';

class ProviderApp extends StateNotifier<String> {
  ProviderApp() : super("");
  ThemeMode themeMode = ThemeMode.system;
  int mainColor = 0xff4050B5;
  UserModel? me;
  final FirebaseService _firebaseService = FirebaseService();

  getUserData() async {
    String myId = _firebaseService.auth.currentUser!.uid;
    await _firebaseService.firestore
        .collection("users")
        .doc(myId)
        .get()
        .then((value) => me = UserModel.fromJson(value.data() ?? {}));
    _firebaseService.firebaseMessaging.requestPermission();
    _firebaseService.firebaseMessaging.getToken().then((value) {
      if (value != null) {
        me!.pushToken = value;
        FireAuth().updateToken();
      }
    });
  }

  changeMode(bool dark) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    sharedPreferences.setBool("dark", themeMode == ThemeMode.dark);
  }

  changeColor(int color) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    mainColor = color;
    sharedPreferences.setInt("color", mainColor);
  }

  getValuesPref() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    bool isDark = sharedPreferences.getBool("dark") ?? false;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    mainColor = sharedPreferences.getInt("color") ?? 0xff4050B5;
  }
}

final providerApp =
    StateNotifierProvider<ProviderApp, String>((ref) => ProviderApp());
