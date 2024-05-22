import 'package:chat_app/Widget/Group/create_group.dart';
import 'package:chat_app/Widget/Group/group_card.dart';
import 'package:chat_app/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../models/group_model.dart';

class GroupHomeScreen extends StatefulWidget {
  const GroupHomeScreen({super.key});

  @override
  State<GroupHomeScreen> createState() => _GroupHomeScreenState();
}

class _GroupHomeScreenState extends State<GroupHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const CreateGroup());
        },
        child: const Icon(Iconsax.message_add_1),
      ),
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("groups")
                      .where("members",
                          arrayContains: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<GroupRoom> items = snapshot.data!.docs.map((e) => GroupRoom.fromJson(e.data())).toList();
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return  GroupCard(groupRoom: items[index],);
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
