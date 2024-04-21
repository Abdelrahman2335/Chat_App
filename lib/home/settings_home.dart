import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingHomeScreen extends StatefulWidget {
  const SettingHomeScreen({super.key});

  @override
  State<SettingHomeScreen> createState() => _SettingHomeScreenState();
}

class _SettingHomeScreenState extends State<SettingHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                minVerticalPadding: 40,
                leading: CircleAvatar(
                  radius: 30,
                ),
                title: Text("Name"),
                trailing: IconButton(onPressed: (){}, icon: Icon(Iconsax.scan_barcode),),
              ),
              Card(
                child: ListTile(
                  title: Text("Profile"),
                  leading: Icon(Iconsax.user),
                  trailing: Icon(Iconsax.arrow_right_3),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Theme"),
                  leading: Icon(Iconsax.color_swatch),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Dark Mode"),
                  leading: Icon(Iconsax.user),
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
              ),
              Card(
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
