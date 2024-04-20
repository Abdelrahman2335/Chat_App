import 'package:chat_app/Widget/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController gName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Text"),
        icon: Icon(Iconsax.tick_circle),
      ),
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
                    CircleAvatar(
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
            Row(
              children: [
                Text("Members"),
                Spacer(),
                Text("1"),
              ],
            ),
            SizedBox(
              height: 17,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: true,
                  checkboxShape: CircleBorder(),
                  title: Text("Abdelrahman"),
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
