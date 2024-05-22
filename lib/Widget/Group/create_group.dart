import 'package:chat_app/Widget/text_field.dart';
import 'package:chat_app/firebase/fire_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/user_model.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController gName = TextEditingController();
  List members = [];
  List myContact = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: members.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                FireData().creatGroup(gName.text, members).then((value) => Navigator.pop(context));
              },
              label: const Text("Done"),
              icon: const Icon(Iconsax.tick_circle),
            )
          : const SizedBox(),
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                    ),
                    Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_a_photo)))
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: CustomField(
                      lable: "Group Name",
                      icon: Iconsax.people,
                      controller: gName),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Divider(),
            ),
            const Row(
              children: [
                Text("Members"),
                Spacer(),
                Text("2"),
              ],
            ),
            const SizedBox(
              height: 17,
            ),

            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)

                      /// don't forget that this line is the reason for give us only the current user info only
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      myContact = snapshot.data!.data()!["my_users"];

                      /// Here we are taking the id from the firebase so we will use it later...
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .where("id",
                                  whereIn: myContact.isEmpty ? [""] : myContact)
                              .snapshots(),

                          /// Here we start using the id that we just taken from the firebase and,
                          /// than we went to firebase and told him to give us the information about this id
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final List<ChatUser> items = snapshot.data!.docs
                                  .map((e) => ChatUser.fromjson(e.data()))
                                  .toList()
                                ..sort((a, b) => a.name!.compareTo(b.name!));
                              return ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return CheckboxListTile(
                                        value:
                                            members.contains(items[index].id),
                                        checkboxShape: const CircleBorder(),
                                        title: Text(items[index].name!),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value! /* this equal to value == true */) {
                                              members.add(items[index].id!);
                                            } else {
                                              members.remove(items[index].id!);
                                            }
                                          });
                                        });
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          });
                    } else {
                      return Container();
                    }
                  }),
            )
            // Expanded(
            //     child: ListView.builder(
            //   itemCount: 2,
            //   itemBuilder: (context, index) {
            //     return CheckboxListTile(
            //       value: true,
            //       checkboxShape: const CircleBorder(),
            //       title:  index % 2 ==0? const Text("Abdelrahman"):const Text("Ali"),
            //       onChanged: (value) {},
            //     );
            //   },
            // )),
          ],
        ),
      ),
    );
  }
}
