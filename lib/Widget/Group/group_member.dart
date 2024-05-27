import 'package:chat_app/Widget/Group/group_edit.dart';
import 'package:chat_app/models/group_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatefulWidget {
  final GroupRoom ChatMembers;
  final List MemberList;
  const GroupMemberScreen(
      {super.key, required this.ChatMembers, required this.MemberList});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.ChatMembers.admin!
        .contains(FirebaseAuth.instance.currentUser!.uid);
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
                          builder: (context) => const EditGroup(),
                        ));
                  },
                  icon: const Icon(Iconsax.user_edit))
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: widget.MemberList.length,
            itemBuilder: (context, index) {

              return ListTile(
                title: Text(widget.MemberList[index]),
                subtitle: isAdmin ? const Text("Admin") : const Text("Member"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isAdmin
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.user_tick),
                          )
                        : Container(),
                    isAdmin
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.trash),
                          )
                        : Container(),
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
