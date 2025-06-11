

import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/message_model.dart';
import '../../../data/repositories/chat/chat_room_repo_impl.dart';

part 'chat_room_provider.g.dart';

@riverpod
Stream<List<Message>> getMessages(ref, String roomId){
  final response = ref.watch(chatRoomRepoProvider);
  return response.getMessages(roomId);
}

@riverpod
Future<void> sendMessage(ref, Message message, String roomId){
  final response = ref.watch(chatRoomRepoProvider);
  return response.sendMessage(message, roomId);
}

@riverpod
Future<void> sendImage(ref, File file, String roomId, String? currentId, String toId) async {
  final response = ref.watch(chatRoomRepoProvider);
  return response.sendImage(file, roomId, currentId, toId);
}

@riverpod
Future<void> readMessage(ref, String roomId, List<Message> msgId) async {
  final repository = ref.watch(chatRoomRepoProvider);
  await repository.readMessage(roomId, msgId);
}

@riverpod
Future<void> deleteMessage(ref, String roomId, List<String> messageId) async {
  final repository = ref.watch(chatRoomRepoProvider);
  await repository.deleteMessage(roomId, messageId);
}