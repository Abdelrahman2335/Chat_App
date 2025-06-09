import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../provider/group/group_home_provider.dart';
import '../widgets/Group/create_group.dart';
import '../widgets/Group/group_card.dart';

class GroupHomeScreen extends ConsumerStatefulWidget {
  const GroupHomeScreen({super.key});

  @override
  ConsumerState<GroupHomeScreen> createState() => _GroupHomeScreenState();
}

class _GroupHomeScreenState extends ConsumerState<GroupHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final groupRooms = ref.watch(groupRoomsProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroup()),
          );
        },
        child: const Icon(Iconsax.message_add_1),
      ),
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: groupRooms.when(
                  data: (groupRooms) {
                    return ListView.builder(
                      itemCount: groupRooms.length,
                      itemBuilder: (context, index) => GroupCard(
                        groupRoom: groupRooms[index],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    log("Error in the groupRooms: $error");
                    return const Center(child: Text("Something went wrong"));
                  },
                  loading: () => const Card()),
            ),
          ],
        ),
      ),
    );
  }
}
