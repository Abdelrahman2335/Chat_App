import 'package:flutter/material.dart';
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
                trailing: IconButton(onPressed: (){}, icon: const Icon(Iconsax.scan_barcode),),
              ),
              const Card(
                child: ListTile(
                  title: Text("Profile"),
                  leading: Icon(Iconsax.user),
                  trailing: Icon(Iconsax.arrow_right_3),
                ),
              ),
              const Card(
                child: ListTile(
                  title: Text("Theme"),
                  leading: Icon(Iconsax.color_swatch),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Dark Mode"),
                  leading: const Icon(Iconsax.user),
                  trailing: Switch(value: isSwitch,
                   onChanged: (value) {
                    setState(() {
                      isSwitch = value;
                    });
                   }),
                ),
              ),
              const Card(
                child: ListTile(
                  title: Text("Sign out"),
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
