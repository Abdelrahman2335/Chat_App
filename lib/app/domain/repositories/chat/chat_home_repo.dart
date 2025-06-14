

import '../../../data/models/room_model.dart';
import '../../../data/models/user_model.dart';

abstract class ChatHomeRepo {
  Future<void> createRoom(String email);

  Stream<List<ChatRoom>> getUserChatRooms();

  Stream<UserModel> chatCard(ChatRoom room);


}
