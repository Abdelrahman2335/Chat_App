import 'package:chat_app/Widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text("Welcome Back",
                    style: Theme.of(context).textTheme.headlineMedium),
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
            ],
          ),
        ),
      ),
    );
  }
}
