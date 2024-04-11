import 'package:chat_app/Widget/text_field.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SetUpProfile extends StatelessWidget {
  const SetUpProfile({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailCon = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen(),), (route) => false);
        }, icon: const Icon(Iconsax.logout_1))],
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
                lable: 'Name',
                icon: Iconsax.direct,
              ),

                  /// note that we can use here GesturDetector.
              
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: myColorScheme.primary,
                    padding: const EdgeInsets.all(16)),
                onPressed: () {},
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
