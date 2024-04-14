import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Abdelrahman"),
            Text(
              "Online",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.call),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.menu_1))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                Row(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width / 2),
                          child:  const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hi!"),
                              Text("10:00 AM",style: TextStyle(fontSize: 10,)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: TextField(
                        maxLines: 7,
                        minLines: 1,
                        decoration: InputDecoration(
                          suffix: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.emoji_emotions_outlined),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          hintText: "Message",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton.filled(
                      onPressed: () {}, icon: const Icon(Iconsax.send_1)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
