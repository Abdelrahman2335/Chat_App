import 'dart:developer';

import 'package:chat_app/app/core/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/error_mapper.dart';
import '../../provider/chat/chat_home_provider.dart';
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
              emailController: emailCon,
              icon: Iconsax.message_add,
              buttonLabel: "Create Chat",
              onPressed: () async {
                // TODO: navigate to the chat, and try to remove context
                try {
                await ref.read(createRoomProvider(emailCon.text).future);

                Navigator.of(context).pop();

                emailCon.clear();
                log("Pressed");
                } catch (error) {


                  String errorMsg = ErrorMap.mapErrorToMessage(error);
                  log("Error message in the UI: $errorMsg");
                  showErrorDialog(context, errorMsg);
                }
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
