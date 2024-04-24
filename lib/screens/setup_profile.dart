import 'package:chat_app/Widget/text_field.dart';
import 'package:chat_app/layout.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SetUpProfile extends StatelessWidget {
  const SetUpProfile({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailCon = TextEditingController();
    TextEditingController passCon = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false);
              },
              icon: const Icon(Iconsax.logout_1))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "Enter Your Name",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                controller: emailCon,
                lable: 'Email',
                icon: Iconsax.direct,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                controller: passCon,
                lable: 'Password',
                icon: Iconsax.password_check,
                secure: true,
              ),

              /// note that we can use here GestureDetector.

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
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailCon.text, password: passCon.text)
                      .then(
                        (value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LayOutApp()),
                            (route) => false),
                      )
                      .onError(
                        (error, stackTrace) =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString(),
                            ),
                          ),
                        ),
                      );
                },
                child: const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
