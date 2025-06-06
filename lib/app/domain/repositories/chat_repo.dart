import '../../data/models/room_model.dart';

abstract class ChatRepo {
  Future<void> createRoom(String email);
  Stream<List<ChatRoom>> getUserChatRooms();

}