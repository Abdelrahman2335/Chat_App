import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LayOutApp extends StatefulWidget {
  const LayOutApp({super.key});

  @override
  State<LayOutApp> createState() => _LayOutAppState();
}

class _LayOutAppState extends State<LayOutApp> {
  int currentIndex = 0;

  /// you have to write this int here so we can setState.
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      Container(
        color: Colors.red,
      ),
      Container(
        color: Colors.black,
      ),
      Container(
        color: Colors.blue,
      ),
      Container(
        color: Colors.green,
      ),
    ];
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        elevation: 1,

        /// elevation is like the backgrond of the bottomNavigationBar

        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.message), label: "Chat"),
          NavigationDestination(icon: Icon(Iconsax.messages), label: "Group"),
          NavigationDestination(icon: Icon(Iconsax.user), label: "Contacts"),
          NavigationDestination(icon: Icon(Iconsax.setting), label: "Setting"),
        ],
      ),
    );
  }
}
