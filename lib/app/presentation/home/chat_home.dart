import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../provider/chat/chat_home_provider.dart';
import '../widgets/Chat/chat_card.dart';
import '../widgets/floating_action_bottom.dart';

class ChatHomeScreen extends ConsumerStatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  ConsumerState<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends ConsumerState<ChatHomeScreen> {
  TextEditingController emailCon = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatRooms = ref.watch(chatRoomsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: ActionBottom(
        emailCon: emailCon,
        icon: Iconsax.message_add,
        bottomName: "Create Chat",
        onPressedLogic: () {

          ref.read(createRoomProvider(emailCon.text).future).then((_) {
            // TODO: navigate to the chat, and try to remove context
            // emailCon.clear();
            // Navigator.pop(context);
          }).catchError((error) {
            log("Error when create room $error");
            String errorMessage = "";
            if (error.toString().contains("Room already exist")) {

              errorMessage = "Room already exist";
            }
            if (error.toString().contains("Email not exist")) {
              errorMessage = "Email not exist";
            }if (error.toString().contains("You can't chat with yourself")) {
              errorMessage = "You can't chat with yourself";
            }
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(errorMessage == ""
                      ? "Something went wrong"
                      : errorMessage),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          });
        },
      ),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatRooms.when(
              data: (rooms) => ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) => ChatCard(room: rooms[index]),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) {
                log("Error in the UI $error");

                return const Center(child: Text("Something went wrong"));
              },
            ),
          )
        ],
      ),
    );
  }
}
