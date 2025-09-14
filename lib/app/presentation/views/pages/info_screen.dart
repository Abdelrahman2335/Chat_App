import 'package:chat_app/app/presentation/views/layout.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/firebase/firebase_auth.dart';
import '../widgets/custom_field.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FireAuth fireAuth = FireAuth();
    TextEditingController nameCon = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              fireAuth.signOut();
            },
            icon: const Icon(Iconsax.logout_1),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please enter your name",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                controller: nameCon,
                label: 'Name',
                icon: Iconsax.user,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: myColorScheme.primary,
                    padding: const EdgeInsets.all(16)),
                onPressed: () async {
                  if (nameCon.text != "".trim()) {
                    await fireAuth.updateProfile(name: nameCon.text);

                    fireAuth.createUser().then(
                          (_) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LayOutApp()),
                              (route) => false),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please Enter your name"),
                      ),
                    );
                  }
                },
                child: const Center(
                  child: Text(
                    "Continue",
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
