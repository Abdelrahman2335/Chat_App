import 'package:chat_app/Widget/Settings/profile.dart';
import 'package:chat_app/Widget/Settings/qr_code.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';

class SettingHomeScreen extends StatefulWidget {
  const SettingHomeScreen({super.key});

  @override
  State<SettingHomeScreen> createState() => _SettingHomeScreenState();
}

class _SettingHomeScreenState extends State<SettingHomeScreen> {
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
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
                leading: const CircleAvatar(
                  radius: 30,
                ),
                title: const Text("Name"),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrCodeScreen(),
                      ),
                    );

                    //   showDialog(
                    //     context: context,
                    //     builder: (context) => AlertDialog(
                    //       alignment: Alignment.center,
                    //       title: Text(
                    //         "QR code",
                    //         style: Theme.of(context).textTheme.titleLarge,
                    //       ),
                    //
                    //       content: QrImageView(
                    //           data: 'QR Code',
                    //           version: QrVersions.auto,
                    //           size: 100.0),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //           child: const Text("Done"),
                    //         ),
                    //       ],
                    //     ),
                    //   );
                  },
                  icon: const Icon(Iconsax.scan_barcode),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen())),
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
                                pickerColor: Colors.red,
                                onColorChanged: (value) {},
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Done"))
                            ],
                          );
                        });
                  },
                  title: Text("Theme"),
                  leading: Icon(Iconsax.color_swatch),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Dark Mode"),
                  leading: const Icon(Iconsax.user),
                  trailing: Switch(
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                      }),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                  title: const Text("Sign out"),
                  trailing: Icon(Iconsax.logout_1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
