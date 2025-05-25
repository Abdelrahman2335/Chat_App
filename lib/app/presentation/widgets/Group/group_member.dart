
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/firebase/fire_database.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/user_model.dart';
import 'group_edit.dart';

class GroupMemberScreen extends StatefulWidget {
  final GroupRoom chatMembers;

  const GroupMemberScreen({
    super.key,
    required this.chatMembers,
  });

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.chatMembers.admin!
        .contains(FirebaseAuth.instance.currentUser!.uid);
    String myId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group members"),
        actions: [
          isAdmin
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditGroup(
                            groupRoom: widget.chatMembers,
                          ),
                        ));
                  },
                  icon: const Icon(Iconsax.user_edit))
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("id", whereIn: widget.chatMembers.members!)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ChatUser> userList = snapshot.data!.docs
                        .map((e) => ChatUser.fromjson(e.data()))
                        .toList();
                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        bool admin = widget.chatMembers.admin!
                            .contains(userList[index].id);
                        return ListTile(
                          title: Text(userList[index].name!),
                          subtitle: admin
                              ? const Text(
                                  "Admin",
                                  style: TextStyle(color: Colors.green),
                                )
                              : const Text("Member"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isAdmin && myId != userList[index].id
                                  ? IconButton(
                                      onPressed: () {
                                        admin
                                            ? FireData().removeAdmin(
                                                widget.chatMembers.id!,
                                                userList[index].id).then((value) => {setState(() {
                                                  widget.chatMembers.admin!.remove(userList[index].id);
                                                }),})
                                            : FireData().promptAdmin(
                                                widget.chatMembers.id!,
                                                userList[index].id).then((value) => {setState(() {
                                          widget.chatMembers.admin!.add(userList[index].id);
                                        }),});
                                      },
                                      icon: const Icon(Iconsax.user_tick),
                                    )
                                  : Container(),
                              isAdmin && myId != userList[index].id
                                  ? IconButton(
                                      onPressed: () {
                                        FireData()
                                            .removeMember(
                                                widget.chatMembers.id!,
                                                userList[index].id)
                                            .then(
                                              (value) => setState(
                                                () {
                                                  widget.chatMembers.members!
                                                      .remove(
                                                          userList[index].id);
                                                },
                                              ),
                                            );
                                      },
                                      icon: const Icon(Iconsax.trash),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
  }
}
