import 'package:chat_app/Widget/text_field.dart';
import 'package:chat_app/layout.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/forget_password.dart';
import 'package:chat_app/screens/info_screen.dart';
import 'package:chat_app/screens/setup_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// We have to use dispose with any Controller.
    TextEditingController emailCon = TextEditingController();
    TextEditingController passCon = TextEditingController();

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
                    child: const Text("Forget Password?"),
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

                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailCon.text, password: passCon.text)
                      .then((value) {
                        if(FirebaseAuth.instance.currentUser!.displayName == null){
                          return const InfoScreen();
                        }else {
                    /// We cannot replace Navigator.pushAndRemoveUntil with Get now because of an error
                    return Navigator.pushAndRemoveUntil(
                        context,
                          MaterialPageRoute(
                            builder: (context) => const LayOutApp(),
                          ),
                        (route) => false);}
                  }).onError(
                        (error, stackTrace) =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                          ),
                        ),
                      );
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
                        color: Theme.of(context).colorScheme.onBackground),
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
