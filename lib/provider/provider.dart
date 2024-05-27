import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderApp with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.system;

  changeMode(bool dark){
     themeMode = dark? ThemeMode.dark :  ThemeMode.light;
    notifyListeners();
  }
}