import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/group_model.dart';
import 'group_screen.dart';

class GroupCard extends ConsumerWidget {
  final GroupRoom groupRoom;

  const GroupCard({
    super.key,
    required this.groupRoom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupScreen(
                groupRoom: groupRoom,
              ),
            )),
        title: Text(groupRoom.name),
        subtitle: Text(
          groupRoom.lastMessage!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          child: Text(groupRoom.name.characters.first.toUpperCase()),
        ),
        trailing:
                  Text(DateFormat.yMMMEd()
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          int.parse(groupRoom.lastMessageTime.toString())))
                      .toString())
            ),

    );
  }
}
