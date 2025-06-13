import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../core/custom_data_time.dart';
import '../../../../data/firebase/fire_database.dart';
import '../../../../data/firebase/fire_storage.dart';
import '../../../../data/models/user_model.dart';
import '../../../provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController aboutCon = TextEditingController();
  String _image = "";
  bool changeName = false;
  bool changeAbout = false;
  final myId = FirebaseAuth.instance.currentUser!.uid;
  UserModel? userInfo;
  String myImage = "";
  String createdDate = "";
  XFile? image;
  getData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(myId)
        .get()
        .then((value) => userInfo = UserModel.fromJson(value.data()!))
        .then((value) {
      setState(() {
        createdDate = value.createdAt.toString();
        aboutCon.text = value.about.toString();
      nameCon.text = value.name.toString();
      myImage = value.image.toString();
      });
    });
  }

  final String currentUserEmail =
      FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    super.initState();
    getData() ?? const Center(child: CircularProgressIndicator());
     createdDate;
  }

  @override
  void dispose() {
    super.dispose();
    nameCon.dispose();
    aboutCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ProviderApp>(context).themeMode == ThemeMode.dark;
    Color colorTheme = isDark ? Colors.white : Colors.black;
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
                        ? myImage == ""
                            ? const CircleAvatar(
                                radius: 60,
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(myImage),
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
                            FireStorage().profileImage(file: File(_image));
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
                    style:
                        TextStyle(color: changeName ? colorTheme : Colors.grey),
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
                        changeAbout = !changeAbout;
                      });
                    },
                    icon: const Icon(Iconsax.edit),
                  ),
                  leading: const Icon(Iconsax.information),
                  title: TextField(
                    controller: aboutCon,
                    style: TextStyle(
                        color: changeAbout ? colorTheme : Colors.grey),
                    enabled: changeAbout,
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
               Card(
                child: ListTile(
                  leading: const Icon(Iconsax.timer_1),
                  title: const Text("Joined on"),
                  subtitle: Text(CustomDateTime.dateFormat(createdDate).toString()),
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
                  if (nameCon.text != "" && aboutCon.text != "") {
                    FireData().editProfile(nameCon.text, aboutCon.text).then(
                      (value) {
                        setState(() {
                          changeAbout = false;
                          changeName = false;
                        });
                      },
                    );
                  }
                  if (_image != "".trim()) {
                    FireStorage().profileImage(file: File(_image));
                  }
                },
                child: Center(
                  child: Text(
                    "SAVE",
                    style: Theme.of(context).textTheme.bodyMedium,
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
