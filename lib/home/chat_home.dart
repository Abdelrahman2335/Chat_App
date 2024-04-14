import 'package:chat_app/Widget/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Iconsax.message_add),
      ),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ChatCard();
              },
            ),
          )
        ],
      ),
    );
  }
}
