
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/models/user_model.dart';
import '../pages/login_screen.dart';
import '../provider/provider.dart';
import '../widgets/Settings/profile.dart';

class SettingHomeScreen extends StatefulWidget {
  const SettingHomeScreen({super.key});

  @override
  State<SettingHomeScreen> createState() => _SettingHomeScreenState();
}

class _SettingHomeScreenState extends State<SettingHomeScreen> {
  String currentUserName = "";
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  UserModel? userInfo;
  NetworkImage? myImage;
  bool noImage = true;

  userinfo() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) => userInfo = UserModel.fromJson(value.data() ?? {}))
        .then(
      (value) {
        setState(() {
          noImage = value.image?.trim() == "".trim() ? true : false;
          myImage = NetworkImage(value.image ?? "");
          currentUserName = value.name!;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userinfo() ?? const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProviderApp>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                minVerticalPadding: 40,
                leading: noImage
                    ? const CircleAvatar()
                    : CircleAvatar(
                        backgroundImage: myImage,
                        radius: 30,
                      ),
                title: Text(currentUserName),
                trailing: IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const QrCodeScreen(),
                    //   ),
                    // );

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        alignment: Alignment.center,
                        title: Text(
                          "QR code",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        content: SizedBox(
                          width: 200,
                          height: 150,
                          child: Center(
                            child: QrImageView(
                              backgroundColor: Colors.white,
                              data: 'QR Code',
                              version: QrVersions.auto,
                            ),
                          ),
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
                  },
                  icon: const Icon(Iconsax.scan_barcode),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  ),
                  title: const Text("Profile"),
                  leading: const Icon(Iconsax.user),
                  trailing: const Icon(Iconsax.arrow_right_3),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: Color(prov.mainColor),
                                onColorChanged: (value) {
                                  prov.changeColor(value.value);
                                },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Done"))
                            ],
                          );
                        });
                  },
                  title: const Text("Theme"),
                  leading: const Icon(Iconsax.color_swatch),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Dark Mode"),
                  leading: const Icon(Iconsax.user),
                  trailing: Switch(
                      value: prov.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        prov.changeMode(value);
                      }),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance
                        .signOut()
                        .onError(
                          (error, stackTrace) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error occur"),
                            ),
                          ),
                        )
                        .then((_) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    });
                  },
                  title: const Text("Sign out"),
                  trailing: const Icon(Iconsax.logout_1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
