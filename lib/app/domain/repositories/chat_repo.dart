import '../../data/models/room_model.dart';

/// You have to create 2 repo one for the home and the second one is for the chat itself.
/// Too many functions and requests to the database, so check if we can use the same repo for both
abstract class ChatRepo {
  Future<void> createRoom(String email);
  Stream<List<ChatRoom>> getUserChatRooms(String userId);

}