import 'package:chat_app/Widget/chat_card.dart';
import 'package:chat_app/Widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  TextEditingController emailCon = TextEditingController();

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Enter Friend Email",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Spacer(),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(
                      Iconsax.scan_barcode,
                      size: 22,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomField(
                  lable: "Email", icon: Iconsax.direct, controller: emailCon),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () {},
                child: Center(
                  child: Text(
                    "Create Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);

          /// Call the function to show bottom sheet we have to use BottomSheet with this way cuz if we use the function directly here we will get error message(No Scaffold widget found.)
        },
        child: const Icon(Iconsax.message_add),
      ),
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ChatCard();
              },
            ),
          )
        ],
      ),
    );
  }
}
