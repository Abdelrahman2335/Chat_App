import 'package:chat_app/Widget/floating_action_bottom.dart';
import 'package:chat_app/firebase/fire_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../Widget/Contacts/contact_card.dart';

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

  getMyContact() async{
    final contact = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => myContact = value.data()!["my_users"]);
  }

  contactLogic(){
     FireData().creatContacts(emailCon.text).then((value) {
       setState(() {
       emailCon.text = "";
     });
       Get.back();
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ActionBottom(
        emailCon: emailCon,
        icon: Iconsax.user_add,
        bottomName: "Add contact", onPressedLogic: contactLogic,
      ),
      appBar: AppBar(
        title: isSearch
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
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
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const ContactCard();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
