import 'dart:developer';

import 'package:chat_app/app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/room_model.dart';
import '../../../data/repositories/chat/chat_home_repo_impl.dart';
import 'chat_room_provider.dart';

part 'chat_home_provider.g.dart';

FirebaseService firebaseService = FirebaseService();

@riverpod
Stream<List<ChatRoom>> chatRooms(ref) {
  final repository = ref.watch(chatRepoProvider);
  return repository.getUserChatRooms();
}

@riverpod
Future<void> createRoom(ref, String email) async {
  final repository = ref.read(chatRepoProvider);
  await repository.createRoom(email);
}

@riverpod
Stream<UserModel> chatCard(ref, ChatRoom room) {
  final repository = ref.watch(chatRepoProvider);
  return repository.chatCard(room);
}

@riverpod
 Future<int> unReadMessages(Ref ref, String roomId) async {
  final repository = ref.watch(getMessagesProvider(roomId));
  int counter =  repository.value?.where((element) {
   if(element.fromId != firebaseService.auth.currentUser!.uid){
     return element.read == '';
   }else{
     return false;
   }

  }).length ?? 0;
  log("Note counter is: $counter");
  return counter;
}
