

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/message_model.dart';
import '../../../data/repositories/chat/chat_room_repo_impl.dart';

part 'chat_room_provider.g.dart';

@riverpod
Stream<List<Message>> getMessages(ref, String roomId){
  final response = ref.watch(chatRoomRepoProvider);
  return response.getMessages(roomId);
}