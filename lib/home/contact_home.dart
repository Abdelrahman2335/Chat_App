import 'dart:async';

import 'package:chat_app/Widget/floating_action_bottom.dart';
import 'package:chat_app/firebase/fire_database.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../Widget/Contacts/contact_card.dart';
import '../firebase/firebase_auth.dart';

class ContactHomeScreen extends StatefulWidget {
  const ContactHomeScreen({super.key});

  @override
  State<ContactHomeScreen> createState() => _ContactHomeScreenState();
}

class _ContactHomeScreenState extends State<ContactHomeScreen> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();
  bool isSearch = false;
  List myContact = [];

  contactLogic() async{

    if (emailCon.text != "" && emailCon.text != FireAuth.user.email) {
      await FireData().creatContacts(emailCon.text).then(
            (value) {
          setState(() {
            emailCon.text = "";
          });
          Get.back();
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          titleTextStyle:
          Theme.of(context).textTheme.bodyMedium,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          title: Text(
            "Invalid Email",
            style: Theme.of(context).textTheme.titleLarge,
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
                                  .where(
                                    (element) => element.name!
                                        .toLowerCase()
                                        .startsWith(
                                            searchCon.text.toLowerCase()),
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
