import 'package:chat_app/app/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/room_model.dart';
import '../../../data/repositories/chat/chat_home_repo_impl.dart';

part 'chat_home_provider.g.dart';

@riverpod
Stream<List<ChatRoom>> chatRooms(ref) {
  final repository = ref.watch(chatRepoProvider);
  return repository.getUserChatRooms();
}

@riverpod
Future<void> createRoom(ref, String email) async {
  final repository = ref.watch(chatRepoProvider);
  await repository.createRoom(email);
}

@riverpod
Stream<UserModel> chatCard(ref, ChatRoom room) {
  final repository = ref.watch(chatRepoProvider);
  return repository.chatCard(room);
}
