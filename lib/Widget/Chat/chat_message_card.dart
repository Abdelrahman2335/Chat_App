import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/firebase/fire_database.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screens/photo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';
import '../../screens/date_time.dart';

class ChatMessageCard extends StatefulWidget {
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
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
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
    bool isDark = Provider.of<ProviderApp>(context).themeMode == ThemeMode.dark;
    Color chatColor = isDark ? Colors.white : Colors.black;
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
                  icon: Icon(Iconsax.message_edit, color: chatColor),
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
                            onTap: () => Get.to(() => PhotoViewScreen(
                                image: widget.messageContent.msg!)),
                            child: CachedNetworkImage(
                              imageUrl: widget.messageContent.msg!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                          )
                        : Text(
                            widget.messageContent.msg!,
                            style: TextStyle(color: chatColor),
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
