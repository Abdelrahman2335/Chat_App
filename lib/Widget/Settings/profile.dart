import 'dart:io';

import 'package:chat_app/firebase/fire_storage.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController infoCon = TextEditingController();
  String _image = "";
  bool changeName = false;
  bool info = false;
  final myId = FirebaseAuth.instance.currentUser!.uid;
  ChatUser? userInfo;
  String me = "";
  getData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(myId)
        .get()
        .then((value) => userInfo = ChatUser.fromjson(value.data()!))
        .then((value) {
      infoCon.text = value.about.toString();
      nameCon.text = value.name.toString();
      me = value.image.toString();
    });
  }

  final String currentUserEmail =
      FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState()  {
    super.initState();
    getData() ?? const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    nameCon.dispose();
    infoCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,

                  /// hard to explain just remove this clipBehavior and you will see the difference
                  children: [
                    _image == ""
                        ?  me == "" ?  const CircleAvatar(
                            radius: 60,
                          ) :  CircleAvatar(
                      radius: 60, backgroundImage: NetworkImage(me),
                    )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(File(_image)),
                          ),
                    Positioned(
                      bottom: -5,
                      right: 5,
                      child: IconButton.filled(
                        onPressed: () async {
                          XFile? image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });
                            FireStorage().profileImage(file: File(image.path));
                          }
                        },
                        icon: const Icon(Iconsax.edit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        changeName = !changeName;
                      });
                    },
                    icon: const Icon(Iconsax.edit),
                  ),
                  leading: const Icon(Iconsax.user_octagon),
                  title: TextField(
                    controller: nameCon,
                    style: TextStyle(
                        color: changeName ? Colors.white : Colors.grey),
                    enabled: changeName,
                    decoration: const InputDecoration(
                      label: Text("Name"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        info = !info;
                      });
                    },
                    icon: const Icon(Iconsax.edit),
                  ),
                  leading: const Icon(Iconsax.information),
                  title: TextField(
                    controller: infoCon,
                    style: TextStyle(color: info ? Colors.white : Colors.grey),
                    enabled: info,
                    decoration: const InputDecoration(
                      label: Text("About"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Iconsax.direct),
                  subtitle: Text(currentUserEmail),
                  title: const Text("Email"),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Iconsax.timer_1),
                  title: Text("Joined on"),
                  subtitle: Text("11/5/2024"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: myColorScheme.primary,
                    padding: const EdgeInsets.all(16)),
                onPressed: () {
                  print(me);
                },
                child: const Center(
                  child: Text(
                    "SAVE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
