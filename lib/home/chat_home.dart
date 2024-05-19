import 'package:chat_app/Widget/chat/chat_card.dart';
import 'package:chat_app/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../Widget/floating_action_bottom.dart';
import '../firebase/fire_database.dart';
import '../firebase/firebase_auth.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  TextEditingController emailCon = TextEditingController();
 void chatLogic() async {

    if (emailCon.text != "" && emailCon.text != FireAuth.user.email) {
      await FireData().createRoom(emailCon.text).then(
            (value) {
          setState(() {
            emailCon.text = "";
          });
          Get.back();
            },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          titleTextStyle:
          Theme.of(context).textTheme.bodyMedium,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          title: Text(
            "Invalid Email",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      );
    }
  }

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
          bottomName: "Create Chat", onPressedLogic: chatLogic,
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

                ///here we are making sure that the current user can see ONLY his chat and not others chat
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

