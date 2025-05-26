
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/firebase/fire_database.dart';
import '../../../data/models/user_model.dart';
import '../Chat/chat_screen.dart';

class ContactCard extends StatelessWidget {
  final ChatUser user;

  const ContactCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    bool noImage = user.image!.trim() == "".trim();
    return Card(
      child: ListTile(
        leading: noImage
            ? CircleAvatar(
                child: Text(user.name!.characters.first.toUpperCase()),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(user.image!),
              ),
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
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          roomId: members.toString(),
                          friendData: user,
                        ),
                      ),
                    ),
                  );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    roomId: members.toString(),
                    friendData: user,
                  ),
                ),
              );
            }
          },
          icon: const Icon(Iconsax.message),
        ),
      ),
    );
  }
}
