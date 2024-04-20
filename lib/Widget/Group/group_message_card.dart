// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMessageCard extends StatelessWidget {
  final int index;
  const GroupMessageCard({
    super.key, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisAlignment:
          index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        index % 2 == 0
            ? IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.message_edit),
              )
            : const SizedBox(),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(index % 2 == 0 ? 16 : 0),
              bottomRight: Radius.circular(index % 2 == 0 ? 0 : 16),
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 2 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  index % 2 != 0 ? const Text("Member name"): const SizedBox(),
                  const Text("Hello!"),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "10:00 am",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      const Icon(
                        Iconsax.tick_circle,
                        size: 15,
                        color: Colors.blueAccent,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
