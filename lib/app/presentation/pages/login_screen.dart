import 'package:chat_app/app/presentation/pages/setup_profile.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../provider/auth/login_viewmodel.dart';
import '../widgets/text_field.dart';
import 'forget_password.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final LoginController _loginController = LoginController();

  /// We have to use dispose with any Controller.
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();

  @override
  void dispose() {
    emailCon.dispose();
    passCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                isEmail: true,
                controller: emailCon,
                label: 'Email',
                icon: Iconsax.direct,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                controller: passCon,
                label: 'Password',
                icon: Iconsax.password_check,
                secure: true,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forget Password?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  /// note that we can use here GestureDetector.
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: myColorScheme.primary,
                    padding: const EdgeInsets.all(16)),
                onPressed: () async {
                  await ref
                      .read(_loginController.loginRepoProvider)
                      .login(emailCon.text, passCon.text);

                  // .then((value) {
                  // if (FirebaseAuth.instance.currentUser!.displayName ==
                  // null) {
                  // return const InfoScreen();
                  // } else {
                  // return Navigator.pushAndRemoveUntil(
                  // context,
                  // MaterialPageRoute(
                  // builder: (context) => const LayOutApp(),
                  // ),
                  // (route) => false);
                  // }
                  // })
                },
                child: const Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16)),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetUpProfile()),
                      (route) => false);
                },
                child: Center(
                  child: Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
