
import 'package:chat_app/firebase/fire_database.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';
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

  @override
  void dispose() {
    super.dispose();
    msgCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.friendData.name!),
            Text(
              widget.friendData.lastSeen!,
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
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.menu_1))
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
                                return ChatMessageCard(
                            messageContent: messageContent[index],
                            index: index,
                          );
                        },
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () => FireData().sendMessage(
                                    widget.friendData.id!,
                                    "Assalamu Alaikum👋",
                                    widget.roomId),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
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
                                icon: const Icon(Icons.emoji_emotions_outlined),
                              ),
                              IconButton(
                                onPressed: () async{
                                  ImagePicker picker  = ImagePicker();
                                  XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                  if(image != null){
                                    FireData().sendMessage(widget.friendData.id!, "Nice you picked an image! we still working on sending images 😀", widget.roomId);
                                  }
                                },
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          hintText: "Message",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
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
                                  widget.roomId)
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
