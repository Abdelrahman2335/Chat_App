import 'dart:async';
import 'dart:developer';
import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../provider/contact/contact_home_provider.dart';
import '../widgets/Contacts/contact_card.dart';
import '../widgets/floating_action_bottom.dart';

class ContactHomeScreen extends ConsumerStatefulWidget {
  const ContactHomeScreen({super.key});

  @override
  ConsumerState<ContactHomeScreen> createState() => _ContactHomeScreenState();
}

class _ContactHomeScreenState extends ConsumerState<ContactHomeScreen> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool isSearch = false;
  List myContact = [];

  Future<void> contactLogic() async {
    if (emailCon.text != "" &&
        emailCon.text != _firebaseService.auth.currentUser!.email) {
      ref.read(addContactProvider(emailCon.text));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          title: Text(
            "Invalid Email",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final getContacts = ref.watch(getContactProvider);

    return Scaffold(
      floatingActionButton: ActionBottom(
        emailCon: emailCon,
        icon: Iconsax.user_add,
        bottomName: "Add contact",
        onPressedLogic: contactLogic,
      ),
      appBar: AppBar(
        title: isSearch
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        Timer(const Duration(seconds: 1), () {
                          setState(() {
                            searchCon.text = value;
                          });
                        });
                      },
                      autofocus: true,
                      controller: searchCon,
                      decoration: const InputDecoration(
                          hintText: "Search", border: InputBorder.none),
                    ),
                  ),
                ],
              )
            : const Text("Contacts"),
        actions: [
          isSearch
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = false;
                      searchCon.text = "";
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: getContacts.when(
                  data: (data) {
                    final items = data
                        .where(
                          (element) => element.name!
                              .toLowerCase()
                              .startsWith(searchCon.text.toLowerCase()),
                        )
                        .toList()
                      ..sort((a, b) => a.name!.compareTo(b.name!));
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ContactCard(
                            user: items[index],
                          );
                        });
                  },
                  error: (error, stackTrace) {
                    log("Error in the getContacts method UI: $error");
                    return const Text("Something went wrong");
                  },
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
