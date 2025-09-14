import 'package:chat_app/app/core/services/notification_helper.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/app/presentation/views/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/presentation/provider/provider.dart';
import 'app/presentation/views/pages/info_screen.dart';
import 'app/presentation/views/pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationHelper().initialize();
  runApp(const ProviderScope(child: MyApp()));
}

ColorScheme myColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(3, 252, 252, 250),
  brightness: Brightness.light,
);
ColorScheme myDarkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.redAccent,
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    final value = ProviderApp();
    return MaterialApp(
      themeMode: value.themeMode,

      /// Note that value = Provider.of<ProviderApp>(context).themeMode.
      /// But we can't use if here so we used Consumer.
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: myColorScheme = ColorScheme.fromSeed(
            seedColor: Color(value.mainColor), brightness: Brightness.light),
      ),
      darkTheme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(value.mainColor),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: myDarkColorScheme.surface,
        textTheme: TextTheme(
            headlineMedium: TextStyle(
              color: myColorScheme.primary,
            ),
            bodyLarge: TextStyle(color: myColorScheme.primary),
            bodyMedium: TextStyle(color: myColorScheme.onPrimary),
            labelSmall: const TextStyle(color: Colors.white60)),
      ),

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
    );
  }
}
