import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatMessageCard extends StatefulWidget {
  const ChatMessageCard({
    super.key,
  });

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  @override
  Widget build(BuildContext context) {
    var index;

    return Row(
      mainAxisAlignment:
          index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        index % 2 == 0
            ? IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.message_edit),
              )
            : SizedBox(),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(index % 2 == 0 ? 16 : 0),
              bottomRight: Radius.circular(index % 2 == 0 ? 0 : 16),
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hi!"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "10:00 am",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
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
