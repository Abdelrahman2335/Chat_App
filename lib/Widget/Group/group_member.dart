import 'package:chat_app/Widget/Group/group_edit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatefulWidget {
  const GroupMemberScreen({super.key});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group members"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditGroup(),
                    ));
              },
              icon: const Icon(Iconsax.user_edit))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                title: const Text("Name"),
                subtitle: const Text("Admin"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.user_tick),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.trash),
                    ),
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
