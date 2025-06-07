import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/firebase/fire_database.dart';
import '../../../data/models/message_model.dart';
import '../../pages/date_time.dart';
import '../../pages/photo_view.dart';

class ChatMessageCard extends ConsumerStatefulWidget {
  final int index;
  final Message messageContent;
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
    if (widget.messageContent.toId == FirebaseAuth.instance.currentUser!.uid) {
      FireData().readMessage(widget.roomId, widget.messageContent.id!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe =
        widget.messageContent.fromId == FirebaseAuth.instance.currentUser!.uid;
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
                    widget.messageContent.type == "image"
                        ? GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhotoViewScreen(
                                        image: widget.messageContent.msg!))),
                            child: CachedNetworkImage(
                              imageUrl: widget.messageContent.msg!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                          )
                        : Text(
                            widget.messageContent.msg!,
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
                                color: widget.messageContent.read == ""
                                    ? Colors.grey
                                    : Colors.blueAccent,
                              )
                            : Container(),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(MyDateTime.timeByHour(widget.messageContent.createdAt!).toString(),style: Theme.of(context).textTheme.labelSmall,),

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
