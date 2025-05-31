import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/room_model.dart';
import '../../../data/repositories/chat/chat_home_repo_impl.dart';

final chatRepoProvider = Provider<ChatHomeRepoImpl>((ref) {
  return ChatHomeRepoImpl();
});

final chatRoomsProvider = StreamProvider<List<ChatRoom>>((ref) {
  final repository = ref.watch(chatRepoProvider);
  return repository.getUserChatRooms();
});

final createRoomProvider = FutureProvider.family<void, String>((ref, email) async {
  final repository = ref.watch(chatRepoProvider);
  await repository.createRoom(email);
});