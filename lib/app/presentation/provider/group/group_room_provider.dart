
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/group_room/group_room_repo_impl.dart';

part 'group_room_provider.g.dart';

@riverpod
Stream<List<Message>> getGroupMessages(ref, String groupId) {
  final repository = ref.watch(groupRoomRepoProvider);
  return repository.getGroupMessages(groupId);
}

@riverpod
Future<List<UserModel>> getGroupMembers(ref, List members) {
  final repository = ref.watch(groupRoomRepoProvider);
  return repository.getGroupMembers(members);
}

@riverpod
Future<void> sendGroupMessage(ref, Message message, String groupId) async {
  final repository = ref.watch(groupRoomRepoProvider);
  await repository.sendGroupMessage(message, groupId);
}

@riverpod
Future<void> sendGroupImage(ref, File file, String groupId, String? currentId, String toId) async {
  final repository = ref.watch(groupRoomRepoProvider);
  await repository.sendGroupImage(file, groupId, currentId, toId);
}