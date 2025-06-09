import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/models/user_model.dart';
import '../../provider/contact/contact_home_provider.dart';
import '../../provider/group/group_home_provider.dart';
import '../text_field.dart';

class CreateGroup extends ConsumerStatefulWidget {
  const CreateGroup({super.key});

  @override
  ConsumerState<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends ConsumerState<CreateGroup> {
  TextEditingController gName = TextEditingController();
  List members = [];
  List myContact = [];

  @override
  dispose() {
    gName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactInfo = ref.watch(getContactProvider);
    return Scaffold(
      floatingActionButton: members.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                if (gName.text.isNotEmpty) {
                  ref.read(
                      createGroupProvider(gName: gName.text, members: members));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Give your group a name"),
                    ),
                  );
                }
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
                      label: "Group Name",
                      icon: Iconsax.people,
                      controller: gName),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Divider(),
            ),
            Row(
              children: [
                const Text("Members"),
                const Spacer(),
                Text(members.length.toString()),
              ],
            ),
            const SizedBox(
              height: 17,
            ),

            Expanded(
              // TODO: Remove the StreamBuilder we don't need live data
              child: contactInfo.when(
                  data: (data) {
                    final List<UserModel> items = data
                      ..sort((a, b) => a.name!.compareTo(b.name!));

                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                              value: members.contains(items[index].id),
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
                  },
                  error: (err, stackTrace) {
                    log("Error in the create group widget $err");
                    log("Stack trace: $stackTrace");
                    return const Center(child: Text("Something went wrong"));
                  },
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
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
