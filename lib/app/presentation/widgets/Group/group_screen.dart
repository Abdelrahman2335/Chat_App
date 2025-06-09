import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/models/group_model.dart';
import '../../../data/models/message_model.dart';

import '../../../data/repositories/group_room/group_room_repo_impl.dart';
import '../../provider/group/group_room_provider.dart';
import 'group_member.dart';
import 'group_message_card.dart';

class GroupScreen extends ConsumerStatefulWidget {
  final GroupRoom groupRoom;

  const GroupScreen({super.key, required this.groupRoom});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  TextEditingController msgCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // bool isDark = Provider.of<ProviderApp>(context).themeMode == ThemeMode.dark;

    final groupMembers =
    ref.read(getGroupMembersProvider(widget.groupRoom.members));
    final messages = ref.watch(getGroupMessagesProvider(widget.groupRoom.id));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.groupRoom.name),
            groupMembers.when(
              data: (groupMembers) {
                return Text(
                  groupMembers.join(", "),
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelMedium,
                );
              },
              error: (error, stackTrace) {
                return const Text("0 Members");
              },
              loading: () => const Text("loading..."),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GroupMemberScreen(
                          chatMembers: widget.groupRoom,
                        ),
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
              child: messages.when(
                  data: (msgs) {
                    if (msgs.isEmpty) {
                      return Center(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(groupRoomRepoProvider).sendGroupMessage(
                                Message(toId: "",
                                    fromId: null,
                                    msg: "Assalamu Alaikum👋",
                                    type: "text",
                                    createdAt: null,
                                    read: ""),

                                widget.groupRoom.id,);

                            // FireData().sendGMessage(
                            //   "Assalamu Alaikum👋",
                            //   widget.groupRoom.id!,
                            //   context,
                            //   widget.groupRoom,
                            // );
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
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Say Assalamu Alaikum",
                                    style:
                                    Theme
                                        .of(context)
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
                  },
                  error: (error, stackTrace) {
                    log(
                        "Error in the group screen while getting messages: $error");
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  },
                  loading: () =>
                  const Center(
                    child: CircularProgressIndicator(),
                  )),
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
                          // hintStyle: TextStyle(
                          //     color: isDark ? Colors.white : Colors.black),
                          // contentPadding: const EdgeInsets.symmetric(
                          //     horizontal: 10, vertical: 10),
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
                          ref.read(groupRoomRepoProvider).sendGroupMessage(
                              Message(toId: "",
                                  fromId: null,
                                  msg: msgCon.text,
                                  type: "text",
                                  createdAt: null,
                                  read: ""),
                              widget.groupRoom.id,);

                          //TODO: Update the messages
                          // FireData()
                          //     .sendGMessage(msgCon.text, widget.groupRoom.id!,
                          //     context, widget.groupRoom)
                          //     .then((value) {
                          //   setState(() {
                          //     msgCon.text = "";
                          //   });
                          // });
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
