import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'text_field.dart';

class ActionBotton extends StatelessWidget {
  const ActionBotton({
    super.key,
    required this.emailCon,
    required this.icon,
    required this.bottonName,
  });

  final TextEditingController emailCon;
  final IconData icon;
  final String bottonName;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(30),
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
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        bottonName,
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
