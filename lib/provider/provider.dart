import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderApp with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  int mainColor = 0xff4050B5;

  changeMode(bool dark) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    sharedPreferences.setBool("dark", themeMode == ThemeMode.dark);
    notifyListeners();
  }

  changeColor(int color) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    mainColor = color;
    sharedPreferences.setInt("color", mainColor);
    notifyListeners();
  }

  getValuesPref() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    bool isDark = sharedPreferences.getBool("dark") ?? false;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    mainColor = sharedPreferences.getInt("color") ?? 0xff4050B5 ;
    notifyListeners();
  }
}
