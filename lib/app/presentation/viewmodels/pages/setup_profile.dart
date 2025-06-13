import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../provider/auth/login_provider.dart';
import '../widgets/text_field.dart';
import 'info_screen.dart';
import 'login_screen.dart';

class SetUpProfile extends ConsumerStatefulWidget {
  const SetUpProfile({super.key});

  @override
  ConsumerState<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends ConsumerState<SetUpProfile> {
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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false);
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
                "Lets create new account!",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
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
                onPressed: () async{
                await  ref
                    .read(loginControllerProvider.notifier)
                    .createUser(emailCon.text, passCon.text)
                    .then(
                      (value) {

                        /// We cannot replace Navigator.pushAndRemoveUntil with Get now because of an error

                        return Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InfoScreen()),
                            (route) => false);
                      },
                    ).onError(
                      (error, stackTrace) =>
                          ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Email or password"),
                        ),
                      ),
                    );
                },
                //
                //

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
