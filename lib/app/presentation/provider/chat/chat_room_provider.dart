import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/message_model.dart';
import '../../../data/repositories/chat/chat_room_repo_impl.dart';

part 'chat_room_provider.g.dart';

@riverpod
Stream<List<Message>> getMessages(Ref ref, String roomId) {
  final response = ref.watch(chatRoomRepoProvider);
  final messages = response.getMessages(roomId);

  return messages;
}

@riverpod
Future<void> sendMessage(Ref ref, Message message, String roomId) {
  final response = ref.watch(chatRoomRepoProvider);
  return response.sendMessage(message, roomId);
}

@riverpod
Future<void> sendImage(
    Ref ref, File file, String roomId, String? currentId, String toId) async {
  final response = ref.watch(chatRoomRepoProvider);
  return response.sendImage(file, roomId, currentId, toId);
}

@riverpod
Future<void> readMessage(Ref ref, String roomId) async {
  log("we are in readMessage method");
  final List<Message> messages =
      await ref.watch(getMessagesProvider(roomId).future);
  final repository = ref.watch(chatRoomRepoProvider);
  await repository.readMessage(roomId, messages);
}

@riverpod
Future<void> deleteMessage(Ref ref, String roomId, List<String> messageId) async {
  final repository = ref.watch(chatRoomRepoProvider);
  await repository.deleteMessage(roomId, messageId);
}
