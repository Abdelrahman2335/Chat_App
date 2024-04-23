import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController infoCon = TextEditingController();
  bool changeName = false;
  bool info = false;

  @override
  void initState() {
    super.initState();
    nameCon.text = "Abdelrahman";
    infoCon.text = "Hi, I'm using chat app";
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
                    const CircleAvatar(
                      radius: 60,
                    ),
                    Positioned(
                      bottom: -5,
                      right: 5,
                      child: IconButton.filled(
                        onPressed: () {},
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
                    enabled: info,
                    decoration: const InputDecoration(
                      label: Text("About"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Iconsax.direct),
                  title: Text("Email"),
                  subtitle: Text("Abdelrahman@gmail.com"),
                ),
              ),const Card(
                child: ListTile(
                  leading: Icon(Iconsax.timer_1),
                  title: Text("Joined on"),
                  subtitle: Text("11/5/2024"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: myColorScheme.primary,
                    padding: const EdgeInsets.all(16)),
                onPressed: () {},
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
