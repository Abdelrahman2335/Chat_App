import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/app/presentation/provider/chat/chat_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/message_model.dart';
import '../../../core/custom_data_time.dart';
import '../../pages/photo_view.dart';

class ChatMessageCard extends ConsumerStatefulWidget {
  final int index;
  final List<Message> messageContent;
  final String roomId;
  final bool selected;

  const ChatMessageCard({
    super.key,
    required this.index,
    required this.messageContent,
    required this.roomId,
    required this.selected,
  });

  @override
  ConsumerState<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends ConsumerState<ChatMessageCard> {
  @override
  void initState() {
    ref.read(readMessageProvider(widget.roomId, widget.messageContent));
      log("read message");
      log("Message id: ${widget.messageContent.map((e)=> e.id)}");
      log("Room id: ${widget.roomId}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

  final  FirebaseService firebaseService = FirebaseService();
    bool isMe =
        widget.messageContent[widget.index].fromId == firebaseService.auth.currentUser!.uid;
    // Color chatColor = isDark ? Colors.white : Colors.black;
    return Container(
      decoration: BoxDecoration(
          color: widget.selected ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isMe
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Iconsax.message_edit,),
                )
              : const SizedBox(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.messageContent[widget.index].type == "image"
                        ? GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhotoViewScreen(
                                        image: widget.messageContent[widget.index].msg!))),
                            child: CachedNetworkImage(
                              imageUrl: widget.messageContent[widget.index].msg!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                          )
                        : Text(
                            widget.messageContent[widget.index].msg!,
                          ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isMe
                            ? Icon(
                                Iconsax.tick_circle,
                                size: 15,
                                color: widget.messageContent[widget.index].read == ""
                                    ? Colors.grey
                                    : Colors.blueAccent,
                              )
                            : Container(),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(CustomDateTime.timeByHour(widget.messageContent[widget.index].createdAt!).toString(),style: Theme.of(context).textTheme.labelSmall,),

                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
