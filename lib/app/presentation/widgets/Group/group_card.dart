import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/group_model.dart';
import '../../../data/models/message_model.dart';
import 'group_screen.dart';

class GroupCard extends StatelessWidget {
  final GroupRoom groupRoom;

  const GroupCard({
    super.key,
    required this.groupRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupScreen(
                groupRoom: groupRoom,
              ),
            )),
        title: Text(groupRoom.name!),
        subtitle: Text(
          groupRoom.lastMessage!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          child: Text(groupRoom.name!.characters.first.toUpperCase()),
        ),
        trailing: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("groups")
                .doc(groupRoom.id)
                .collection("messages")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final unReadList = (snapshot.data!.docs)
                  .map((e) => Message.fromJson(e.data()))
                  .where((element) => element.read == "")
                  .where((element) =>
                      element.fromId != FirebaseAuth.instance.currentUser!.uid);
              return unReadList.isNotEmpty
                  ? Badge(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      label: Text(unReadList.length.toString()),
                      largeSize: 30,
                    )
                  : Text(DateFormat.yMMMEd()
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          int.parse(groupRoom.lastMessageTime.toString())))
                      .toString());
            }),
      ),
    );
  }
}
