import 'package:chat_app/Widget/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/message_model.dart';
import '../../../data/models/room_model.dart';
import '../../../data/models/user_model.dart';
import '../../pages/date_time.dart';

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
                  subtitle: Text(item.lastMessage! == ""
                      ? chatUser.about!
                      : item.lastMessage!,maxLines: 1,overflow: TextOverflow.ellipsis,),
                  leading: chatUser.image == ""
                      ? CircleAvatar(
                          child: Text(chatUser.name!.characters.first.toUpperCase()),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(chatUser.image!),
                        ),
                  trailing: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("rooms")
                          .doc(item.id)
                          .collection("messages")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        final unReadList = (snapshot.data!.docs)
                            .map((e) => Message.fromjson(e.data()))
                            .where((element) => element.read == "")
                            .where((element) =>
                                element.fromId !=
                                FirebaseAuth.instance.currentUser!.uid);
                        return unReadList.isNotEmpty
                            ? Badge(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                label: Text(unReadList.length.toString()),
                                largeSize: 30,
                              )
                            : Text(MyDateTime.timeByHour(item.lastMessageTime!).toString());
                      })),
            );
          } else {
            return Container();
          }
        });
  }
}
