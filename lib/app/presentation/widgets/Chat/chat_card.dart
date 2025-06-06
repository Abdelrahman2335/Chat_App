import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/message_model.dart';
import '../../../data/models/room_model.dart';
import '../../pages/date_time.dart';
import '../../provider/chat/chat_home_provider.dart';
import 'chat_screen.dart';

class ChatCard extends ConsumerWidget {
  final ChatRoom room;

  const ChatCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context, ref) {
    final  chatCard = ref.watch(chatCardProvider(room));
    return chatCard.when(
      data: (chatUser) {
        log("Chat User is: ${chatUser.name}");
        return Card(
          child: ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      friendData: chatUser,
                      roomId: room.id!,
                    ),
                  )),
              title: Text(chatUser.name!),
              subtitle: Text(
                room.lastMessage! == "" ? chatUser.about! : room.lastMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: chatUser.image == ""
                  ? CircleAvatar(
                      child:
                          Text(chatUser.name!.characters.first.toUpperCase()),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(chatUser.image!),
                    ),
              // TODO: Remove this stream when refactor the message screen.
              trailing: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("rooms")
                      .doc(room.id)
                      .collection("messages")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error with Stream: ${snapshot.error}");
                    }

                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final unReadList = (snapshot.data!.docs)
                        .map((e) => Message.fromJson(e.data()))
                        .where((element) => element.read == "")
                        .where((element) =>
                            element.fromId !=
                            FirebaseAuth.instance.currentUser!.uid);
                    return unReadList.isNotEmpty
                        ? Badge(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            label: Text(unReadList.length.toString()),
                            largeSize: 30,
                          )
                        : Text(MyDateTime.timeByHour(room.lastMessageTime!)
                            .toString());
                  })),
        );
      },
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => const Card(),
    );
  }
}
