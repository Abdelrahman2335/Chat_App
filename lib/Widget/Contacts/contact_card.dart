// ignore_for_file: unrelated_type_equality_checks

import 'package:chat_app/Widget/Chat/chat_screen.dart';
import 'package:chat_app/firebase/fire_database.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ContactCard extends StatelessWidget {
  final ChatUser user;

  const ContactCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(user.name!),
        subtitle: Text(
          user.about!,
          maxLines: 1,
        ),
        trailing: IconButton(
          onPressed: () {
            List<String> members = [
              user.id!,
              FirebaseAuth.instance.currentUser!.uid,
            ]..sort((a, b) => a.compareTo(b));
            if (members !=
                FirebaseFirestore.instance.collection("rooms").doc()) {
              FireData().createRoom(user.email!).then(
                    (value) => Get.to(
                      () => ChatScreen(
                          roomId: members.toString(), friendData: user),
                    ),
                  );
            } else {
              Get.to(
                () => ChatScreen(roomId: members.toString(), friendData: user),
              );
            }
          },
          icon: const Icon(Iconsax.message),
        ),
      ),
    );
  }
}
