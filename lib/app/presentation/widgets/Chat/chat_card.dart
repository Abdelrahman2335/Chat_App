import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/room_model.dart';
import '../../../core/custom_data_time.dart';
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
    final chatCard = ref.watch(chatCardProvider(room));
    final unreadMessages = ref.watch(unReadMessagesProvider(room.id!));
    return chatCard.when(
      data: (chatUser) {
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
                    child: Text(chatUser.name!.characters.first.toUpperCase()),
                  )
                : CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      chatUser.image!,
                    ),
                  ),
            trailing: unreadMessages.when(
                data: (counter) {
             return     room.lastMessage == ""
                      ? const SizedBox()
                      : counter != 0
                          ? Badge(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              label: Text(counter.toString()),
                              largeSize: 30,
                            )
                          : Text(CustomDateTime.timeByHour(room.lastMessageTime!)
                              .toString());
                },
                error: (error, stackTrace) => const Card(),
                loading: () => const Card()),
          ),
        );
      },
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => const Card(),
    );
  }
}
