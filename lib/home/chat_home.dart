import 'package:chat_app/Widget/chat/chat_card.dart';
import 'package:chat_app/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  void dispose() {
    super.dispose();
    emailCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: ActionBottom(
          emailCon: emailCon,
          icon: Iconsax.message_add,
          bottomName: "Create Chat",
        ),

      /// Bro this is function don't forget.
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("rooms")
                    .where("members",
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),

                ///here we are making sure that the current user can see ONLY this chat and not others chat
                ///why here we use snapshots cuz the stream need this check stream
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ChatRoom> items = snapshot.data!.docs
                        .map(
                          (e) => ChatRoom.fromjson(
                            e.data(),
                          ),
                        )
                        .toList()
                      ..sort(
                        (item1, item2) => item2.lastMessageTime!
                            .compareTo(item1.lastMessageTime!),
                      );

                    ///Simple we did just as follow [Hi snapshot I need the data, what data?
                    /// the doc man, which one? all of it! but how? I will use a map, Okay that's fine]
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return  ChatCard(item: items[index],);
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}

