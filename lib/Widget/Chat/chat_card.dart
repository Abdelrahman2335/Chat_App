import 'package:chat_app/Widget/chat/chat_screen.dart';
import 'package:chat_app/models/room_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final ChatRoom item;

  const ChatCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    /// this is not current user id this is his friend id
    String userId = item.members!
        .where((element) => element != FirebaseAuth.instance.currentUser!.uid)
        .first;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ChatUser chatUser = ChatUser.fromjson(snapshot.data!.data()!);
            return Card(
              child: ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        friendData: chatUser,
                        roomId: item.id!,
                      ),
                    )),
                title: Text(chatUser.name!),
                subtitle: Text(item.lastMessage! == ""? "Let's chat 😀" :item.lastMessage!),
                leading: const CircleAvatar(),
                trailing: Badge(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  label: const Text("1"),
                  largeSize: 30,
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
