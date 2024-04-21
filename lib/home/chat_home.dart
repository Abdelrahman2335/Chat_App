import 'package:chat_app/Widget/chat/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../Widget/floating_action_botton.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  TextEditingController emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ActionBotton(emailCon: emailCon, icon: Iconsax.message_add, bottonName: "Create Chat",),
      appBar: AppBar(
        title: const Text("Chat"),
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

