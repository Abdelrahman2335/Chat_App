// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';
import '../../screens/photo_view.dart';

class GroupMessageCard extends StatelessWidget {
  final Message message;
  final int index;

  const GroupMessageCard({
    super.key,
    required this.index,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = message.fromId == FirebaseAuth.instance.currentUser!.uid;
    bool isDark = Provider.of<ProviderApp>(context).themeMode == ThemeMode.dark;
    Color chatColor = isDark ? Colors.white : Colors.black;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(message.fromId)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    isMe
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.message_edit),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width / 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              !isMe
                                  ?

                                  /// this is equal to if it's not me
                                  Text(
                                      snapshot.data!.data()!["name"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    )
                                  : const SizedBox(),
                              Text(message.msg!,style:
                              Theme.of(context).textTheme.labelLarge),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  message.type == "image"
                                      ? GestureDetector(
                                          onTap: () => Get.to(() =>
                                              PhotoViewScreen(
                                                  image: message.msg!)),
                                          child: CachedNetworkImage(
                                            imageUrl: message.msg!,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                          ),
                                        )
                                      : Text(
                                          message.msg!,
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
                                              color: message.read == ""
                                                  ? Colors.grey
                                                  : Colors.blueAccent,
                                            )
                                          : Container(),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        DateFormat.yMMMEd()
                                            .format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                int.parse(message.createdAt!),
                                              ),
                                            )
                                            .toString(),
                                        style: TextStyle(color: chatColor),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    message.createdAt!,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  isMe
                                      ? const Icon(
                                          Iconsax.tick_circle,
                                          size: 15,
                                          color: Colors.blueAccent,
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Container();
        });
  }
}
