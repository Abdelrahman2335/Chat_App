import 'package:chat_app/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            )),
        title: const Text("Abdelrahman"),
        subtitle: const Text("Hi"),
        leading: const CircleAvatar(),
        trailing: Badge(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          label: const Text("1"),
          largeSize: 30,
        ),
      ),
    );
  }
}
