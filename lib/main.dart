import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/layout.dart';
import 'package:chat_app/provider/provider.dart';
import 'package:chat_app/screens/info_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

ColorScheme myColorScheme =
    ColorScheme.fromSeed(seedColor : const Color.fromARGB(3, 252, 252,250), brightness: Brightness.light);
ColorScheme myDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.redAccent, brightness: Brightness.dark,);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderApp(),
      child: Consumer<ProviderApp>(
        builder: (context, value, child) => GetMaterialApp(
          themeMode: value.themeMode,
          /// Note that value = Provider.of<ProviderApp>(context).themeMode.
          /// But we can't we if here so we used Consumer.
          debugShowCheckedModeBanner: false,
          theme: ThemeData().copyWith(colorScheme: myColorScheme),
          darkTheme: ThemeData().copyWith(colorScheme: myDarkColorScheme,scaffoldBackgroundColor:myDarkColorScheme.background),

          home: StreamBuilder(

            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (FirebaseAuth.instance.currentUser!.displayName == null) {
                  return const InfoScreen();
                } else {
                  return const LayOutApp();
                }
              } else {
                return const LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
