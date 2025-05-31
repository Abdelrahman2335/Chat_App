
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/firebase/fire_database.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/user_model.dart';
import '../text_field.dart';


class EditGroup extends StatefulWidget {
  final GroupRoom groupRoom;

  const EditGroup({super.key, required this.groupRoom});

  @override
  State<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  TextEditingController gName = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      gName.text = widget.groupRoom.name!;
    });
  }

  @override
  void dispose() {

    super.dispose();
    gName.dispose();
  }

  List members = [];
  List myContact = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FireData()
              .editGroup(widget.groupRoom.id!, gName.text, members)
              .then((value) => Navigator.pop(context));
        },
        label: const Text("Done"),
        icon: const Icon(Iconsax.tick_circle),
      ),
      appBar: AppBar(
        title: const Text("Edit Group"),
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
                    
                    controller: gName,
                    label: "Group Name",
                    icon: Iconsax.people,
                    
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Divider(),
            ),
            Row(
              children: [
                const Text("Add Members"),
                const Spacer(),
                Text(members.length.toString()),
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
                              final List<UserModel> items = snapshot.data!.docs
                                  .map((e) => UserModel.fromJson(e.data()))
                                  .where((element) => !widget.groupRoom.members!
                                      .contains(element.id))
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
            ),
          ],
        ),
      ),
    );
  }
}
