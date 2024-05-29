import 'package:chat_app/firebase/firebase_auth.dart';
import 'package:chat_app/home/chat_home.dart';
import 'package:chat_app/home/contact_home.dart';
import 'package:chat_app/home/group_home.dart';
import 'package:chat_app/home/settings_home.dart';
import 'package:chat_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LayOutApp extends StatefulWidget {
  const LayOutApp({super.key});

  @override
  State<LayOutApp> createState() => _LayOutAppState();
}

class _LayOutAppState extends State<LayOutApp> {
  @override
  void initState() {
    Provider.of<ProviderApp>(context, listen: false).getValuesPref();
    Provider.of<ProviderApp>(context, listen: false).getUserData();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if(message.toString() == "AppLifecycleState.resumed"){
        FireAuth().updateStatus(true);
      }else{
        FireAuth().updateStatus(false);
      }
      return Future.value(message);
    });
    super.initState();
  }
  int currentIndex = 0;
  PageController pageController = PageController();
  /// you have to write this int here so we can setState.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        controller: pageController,
        children: const [
          ChatHomeScreen(),
          GroupHomeScreen(),
          ContactHomeScreen(),
          SettingHomeScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 1,

        /// elevation is like the background of the bottomNavigationBar

        selectedIndex: currentIndex,
        onDestinationSelected: (value) { /// Here we are navigate throw navigation bar so if we have any problem in the bar we have to back here.
          setState(() {
            currentIndex = value;
            pageController.jumpToPage(value);
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.message), label: "Chat"),
          NavigationDestination(icon: Icon(Iconsax.messages), label: "Group"),
          NavigationDestination(icon: Icon(Iconsax.user), label: "Contacts"),
          NavigationDestination(icon: Icon(Iconsax.setting), label: "Settings"),
        ],
      ),
    );
  }
}
