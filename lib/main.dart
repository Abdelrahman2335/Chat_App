import 'package:chat_app/Widget/Group/group_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

var myColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);
var myDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(colorScheme: myColorScheme),
      darkTheme: ThemeData().copyWith(colorScheme: myDarkColorScheme),
      home: const GroupScreen(),
    );
  }
}
