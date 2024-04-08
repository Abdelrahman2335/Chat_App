import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

var myColorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);
var myDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(colorScheme: myColorScheme),
      darkTheme: ThemeData().copyWith(colorScheme: myColorScheme),
      home: LoginScreen(),
    );
  }
}
