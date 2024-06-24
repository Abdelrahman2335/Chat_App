import 'dart:io';
import 'package:chat_app/firebase/fire_database.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../firebase/fire_storage.dart';
import '../../models/user_model.dart';
import '../../screens/date_time.dart';
import 'chat_message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser friendData;

  /// on the course he use chatUser not friendData
  final String roomId;

  const ChatScreen({super.key, required this.roomId, required this.friendData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgCon = TextEditingController();
  List<String> selectedMsg = [];
  List<String> copyMsg = [];
  List<String> senderId = [];

  @override
  void dispose() {
    super.dispose();
    msgCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool msgOwner = !senderId.contains(widget.friendData.id);

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color color = isDark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.friendData.name!),
            Text(
                MyDateTime.timeByHour(widget.friendData.lastSeen!).toString(),
              style: Theme.of(context).textTheme.labelMedium,

            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.call),
          ),
          selectedMsg.isNotEmpty
              ? PopupMenuButton(
                  icon: const Icon(Icons.menu),
                  itemBuilder: (context) {
                    if (msgOwner) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            FireData().deleteMsg(widget.roomId, selectedMsg);
                            setState(() {
                              selectedMsg.clear();
                              copyMsg.clear();
                            });
                          },
                          value: "itemOne",
                          child: const Text("Trash"),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: copyMsg.join("")));
                            setState(() {
                              copyMsg.clear();
                              selectedMsg.clear();
                            });
                          },
                          value: "itemTow",
                          child: const Text("Copy"),
                        ),
                      ];
                    } else {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: copyMsg.join("")));
                            setState(() {
                              copyMsg.clear();
                              selectedMsg.clear();
                            });
                          },
                          value: "itemTow",
                          child: const Text("Copy"),
                        ),
                      ];
                    }
                  })
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("rooms")
                      .doc(widget.roomId)
                      .collection("messages")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Message> messageContent = snapshot.data!.docs
                          .map((e) => Message.fromjson(e.data()))
                          .toList()
                        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                      return messageContent.isNotEmpty
                          ? ListView.builder(
                              reverse: true,
                              itemCount: messageContent.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedMsg.isNotEmpty) {
                                        if (selectedMsg.contains(
                                            messageContent[index].id)) {
                                          selectedMsg
                                              .remove(messageContent[index].id);
                                          senderId.remove(
                                              messageContent[index].fromId!);

                                          ///if we have content remove it
                                        } else {
                                          selectedMsg
                                              .add(messageContent[index].id!);
                                          senderId.add(
                                              messageContent[index].fromId!);

                                          ///if we don't have content add this one
                                        }
                                      }

                                      ///if selectedMsg is empty

                                      ///Copy messages
                                      copyMsg.isNotEmpty
                                          ? messageContent[index].type == "text"
                                              ? copyMsg.contains(
                                                      messageContent[index].id)
                                                  ? copyMsg.remove(
                                                      messageContent[index]
                                                          .msg!)
                                                  : copyMsg.add(
                                                      messageContent[index]
                                                          .msg!)
                                              : null

                                          ///if the type is not text
                                          : null;

                                      ///if copyMsg is empty
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      ///Select the id of the messages
                                      if (selectedMsg
                                          .contains(messageContent[index].id)) {
                                        selectedMsg
                                            .remove(messageContent[index].id);
                                        senderId.remove(
                                            messageContent[index].fromId!);
                                      } else {
                                        selectedMsg
                                            .add(messageContent[index].id!);
                                        senderId
                                            .add(messageContent[index].fromId!);
                                      }

                                      ///Copy the messages
                                      messageContent[index].type == "text"
                                          ? copyMsg.contains(
                                                  messageContent[index].id)
                                              ? copyMsg.remove(
                                                  messageContent[index].msg!)
                                              : copyMsg.add(
                                                  messageContent[index].msg!)
                                          : null;
                                    });
                                  },
                                  child: ChatMessageCard(
                                    messageContent: messageContent[index],
                                    index: index,
                                    roomId: widget.roomId,
                                    selected: selectedMsg
                                        .contains(messageContent[index].id),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () => FireData().sendMessage(
                                    widget.friendData.id!,
                                    "Say Assalamu Alaikum 👋",
                                    widget.roomId,
                                    context,
                                    widget.friendData),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "👋",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          "Say Assalamu Alaikum",
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: TextField(
                        style: TextStyle(
                            color: color),
                        controller: msgCon,
                        maxLines: 7,
                        minLines: 1,
                        decoration: InputDecoration(
                          suffix: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    FireStorage().sendImage(
                                        file: File(image.path),
                                        roomId: widget.roomId,
                                        uid: widget.friendData.id!,
                                        chatUser: widget.friendData,
                                        context: context);
                                  }
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),

                          border: InputBorder.none,
                          hintText: "Message",
                          hintStyle: TextStyle(
                              color:color),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 7.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton.filled(
                      onPressed: () {
                        if (msgCon.text.isNotEmpty) {
                          FireData()
                              .sendMessage(widget.friendData.id!, msgCon.text,
                                  widget.roomId, context, widget.friendData)
                              .then((value) => setState(() {
                                    msgCon.text = "";
                                  }));
                        }
                      },
                      icon: const Icon(Iconsax.send_1)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
