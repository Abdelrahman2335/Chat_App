import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("Name"),
        subtitle: null,
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Iconsax.message),
        ),
      ),
    );
  }
}
