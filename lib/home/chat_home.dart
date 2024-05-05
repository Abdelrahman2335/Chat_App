import 'package:chat_app/Widget/chat/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../Widget/floating_action_bottom.dart';

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
      floatingActionButton: SingleChildScrollView(
        child: ActionBottom(
          emailCon: emailCon,
          icon: Iconsax.message_add,
          bottomName: "Create Chat",
        ),
      ),

      /// Bro this is function don't forget.
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

