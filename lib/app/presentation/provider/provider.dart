
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  getUserData() async {
    String myId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(myId)
        .get()
        .then((value) => me = UserModel.fromJson(value.data()??{}));
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((value) {
      if (value != null) {
        me!.pushToken = value;
        FireAuth().updateToken(value);
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

final providerApp = StateNotifierProvider<ProviderApp, String>(
    (ref) => ProviderApp());
