import 'dart:developer';

import 'package:chat_app/Widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EditGroup extends StatefulWidget {
  const EditGroup({super.key});

  @override
  State<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  TextEditingController gName = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
          gName.text = "name";

    });
  }

  @override
  void dispose() {

    super.dispose();
    gName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {log(gName.text);},
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
                    lable: "Group Name",
                    icon: Iconsax.people,
                    
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Divider(),
            ),
            const Row(
              children: [
                Text("Add Members"),
                Spacer(),
                Text("2"),
              ],
            ),
            const SizedBox(
              height: 17,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: true,
                  checkboxShape: const CircleBorder(),
                  title: index % 2 == 0
                      ? const Text("Mahmoud")
                      : const Text("Khalid"),
                  onChanged: (value) {},
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
