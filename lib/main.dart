import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/layout.dart';
import 'package:chat_app/screens/info_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

var myColorScheme =
    ColorScheme.fromSeed(seedColor : Colors.blue, brightness: Brightness.light);
var myDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(colorScheme: myColorScheme),
      darkTheme: ThemeData().copyWith(colorScheme: myDarkColorScheme),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            if (FirebaseAuth.instance.currentUser!.displayName == null) {

              return const InfoScreen();
            } else  {
              return const LayOutApp();
            }
          } else {
            return const LoginScreen();
          }

        },
      ),
    );
  }
}
