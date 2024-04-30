import 'package:chat_app/layout.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_optionsdart pub global activate flutterfire_cli.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

var myColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);
var myDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(colorScheme: myColorScheme),
      darkTheme: ThemeData().copyWith(colorScheme: myDarkColorScheme),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          /// note you can use ? : rather than if and else but in this case you will need to use Navigator.push in sign out of the app
          if (snapshot.hasData) {
            return LayOutApp();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
