import 'dart:developer';

import 'package:chat_app/app/data/repositories/group_room/group_home_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/group_model.dart';
import 'group_room_provider.dart';

part 'group_home_provider.g.dart';

final FirebaseService _firebaseService = FirebaseService();

@riverpod
Stream<List<GroupRoom>> groupRooms(Ref ref) {
  final repository = ref.watch(groupHomeRepoImplProvider);
  return repository.getUserGroups();
}

@riverpod
Future<void> createGroup(
  Ref ref, {
  required String gName,
  required List<String> members,
}) async {
  final repository = ref.read(groupHomeRepoImplProvider);
  await repository.createGroup(gName, members);
}

@riverpod
Future<int> unReadMessages(Ref ref, String groupId) async {
  final repository = ref.watch(getGroupMessagesProvider(groupId));
  int counter = repository.value?.where((element) {
        if (element.senderId != _firebaseService.auth.currentUser!.uid) {
          return element.read == '';
        } else {
          return false;
        }
      }).length ??
      0;
  log("Note counter is: $counter");
  return counter;
}
