import 'package:chat_app/firebase/fire_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'text_field.dart';

class ActionBottom extends StatelessWidget {
  const ActionBottom({
    super.key,
    required this.emailCon,
    required this.icon,
    required this.bottomName,
  });

  final TextEditingController emailCon;
  final IconData icon;
  final String bottomName;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20).add(
                EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),

                /// Here we are using MediaQuery to push the BottomSheet to the top
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Enter Friend Email",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.scan_barcode,
                            size: 22,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomField(
                        lable: "Email",
                        icon: Iconsax.direct,
                        controller: emailCon),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        if(emailCon.text.isNotEmpty){
                      FireData().createRoom(emailCon.text).then(
                            (value) {
                              Navigator.pop(context);
                            },
                          );
                    }},
                      child: Center(
                        child: Text(
                          bottomName,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
            );
          },
        );
      },
      child: Icon(icon),
    );
  }
}
