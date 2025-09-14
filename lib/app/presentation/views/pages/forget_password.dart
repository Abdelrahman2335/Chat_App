import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/custom_field.dart';
import 'login_screen.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailCon = TextEditingController();


    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reset Password",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "Please Enter Your Email",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                controller: emailCon,
                label: 'Email',
                icon: Iconsax.direct,
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
                      .sendPasswordResetEmail(email: emailCon.text)
                      .then(
                    (value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen()), (route) => false);

                      return ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Email sent check you email"),
                        ),
                      );
                    },
                  ).onError(
                    (error, stackTrace) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid Email"),
                      ),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    "SEND EMAIL",
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
