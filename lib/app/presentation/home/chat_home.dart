
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
    final chatRoomsAsync = ref.watch(chatRoomsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: ActionBottom(
        emailCon: emailCon,
        icon: Iconsax.message_add,
        bottomName: "Create Chat",
        onPressedLogic: () {
          // invalid email
          // room already exist
          // room created successfully
          ref.read(createRoomProvider(emailCon.text).future)
              .then((_) {
                // TODO: navigate to the chat.
                emailCon.clear();
                Navigator.pop(context);
          })
              .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
            Navigator.pop(context);
          });

        },
      ),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatRoomsAsync.when(
              data: (rooms) => ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) => ChatCard(item: rooms[index]),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          )
        ],
      ),
    );
  }
}
