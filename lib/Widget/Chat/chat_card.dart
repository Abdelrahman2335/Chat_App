import 'package:chat_app/Widget/chat/chat_screen.dart';
import 'package:chat_app/models/room_model.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final ChatRoom item;
  const ChatCard({
    super.key, required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  ChatScreen(roomId: item.id!,),
            )),
        title: const Text("Abdelrahman"),
        subtitle:  Text(item.lastMessage.toString()),
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
