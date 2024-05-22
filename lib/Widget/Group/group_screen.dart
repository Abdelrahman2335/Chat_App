import 'package:chat_app/Widget/Group/group_member.dart';
import 'package:chat_app/Widget/Group/group_message_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Group name"),
            Text(
              "Abdelrahman, Ali, Ahmed",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroupMemberScreen(),
                  ));
            },
            icon: const Icon(Iconsax.user),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return  GroupMessageCard(index: index,);
                },
              ),

              // child: Center(
              //   child: GestureDetector(
              //     onTap: () {
              //       log("Taped!");
              //     },
              //     child: Card(
              //       child: Padding(
              //         padding: const EdgeInsets.all(12.0),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               "👋",
              //               style: Theme.of(context).textTheme.displayMedium,
              //             ),
              //             const SizedBox(height: 16,),
              //             Text(
              //               "Say Assalamu Alaikum",
              //               style: Theme.of(context).textTheme.bodyMedium,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: TextField(
                        maxLines: 7,
                        minLines: 1,
                        decoration: InputDecoration(
                          suffix: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.emoji_emotions_outlined),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          hintText: "Message",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton.filled(
                      onPressed: () {}, icon: const Icon(Iconsax.send_1)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
