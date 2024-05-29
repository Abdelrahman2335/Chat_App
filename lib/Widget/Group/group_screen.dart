import 'package:chat_app/Widget/Group/group_member.dart';
import 'package:chat_app/Widget/Group/group_message_card.dart';
import 'package:chat_app/firebase/fire_database.dart';
import 'package:chat_app/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/message_model.dart';

class GroupScreen extends StatefulWidget {
  final GroupRoom groupRoom;


  const GroupScreen({super.key, required this.groupRoom});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController msgCon = TextEditingController();
  List memberList = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.groupRoom.name!),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("id", whereIn: widget.groupRoom.members)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.hasData) {

                    /// Here we are taking the Ids that are in the group only, and then we make a for loop,
                    /// that loops on the data in the doc that = to users Id. and if you remember that in the collection users,
                    /// we have doc that named with the Id of the user.
                    for(var x in snapshot.data!.docs ){
                      memberList.add(x.data()["name"]);
                    }
                    return Text(
                      memberList.join(", "),
                      style: Theme.of(context).textTheme.labelMedium,
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  GroupMemberScreen(chatMembers: widget.groupRoom,),
                  ));
            },
            icon: const Icon(Iconsax.user),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("groups")
                      .doc(widget.groupRoom.id!)
                      .collection("messages")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<Message> msgs = snapshot.data!.docs
                          .map((e) => Message.fromjson(e.data()))
                          .toList()
                        ..sort(
                          (a, b) => b.createdAt!.compareTo(a.createdAt!),
                        );
                      if (msgs.isEmpty) {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              FireData().sendGMessage("Say Assalamu Alaikum👋",
                                  widget.groupRoom.id!,context, widget.groupRoom,);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        return ListView.builder(
                          reverse: true,
                          itemCount: msgs.length,
                          itemBuilder: (context, index) {
                            return GroupMessageCard(
                              index: index,
                              message: msgs[index],
                            );
                          },
                        );
                      }
                    } else {
                      return Container();
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
                                onPressed: () {},
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          hintText: "Message",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                              .sendGMessage(msgCon.text, widget.groupRoom.id!,context,widget.groupRoom)
                              .then((value) {
                            setState(() {
                              msgCon.text = "";
                            });
                          });
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
