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
                child: ListView.builder(
                    reverse: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: index % 2 == 0
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          index % 2 == 0?
                          IconButton(onPressed: (){}, icon: Icon(Iconsax.message_edit),): SizedBox(),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(index % 2 == 0 ? 16 : 0),
                                bottomRight:
                                    Radius.circular(index % 2 == 0 ? 0 : 16),
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.sizeOf(context).width / 2),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
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
                    })),
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
                              horizontal: 10, vertical: 10),
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
