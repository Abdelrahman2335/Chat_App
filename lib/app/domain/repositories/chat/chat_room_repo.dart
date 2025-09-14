import 'dart:io';

import '../../../data/models/message_model.dart';

abstract class ChatRoomRepo {
  Stream<List<Message>> getMessages(String roomId);

  Future<void> sendMessage(Message message, String roomId);

  Future<void> sendImage(
    File file,
    String roomId,
    String? currentId,
    String receiverId,
  );

  Future<void> readMessage(String roomId, List<Message> messages);

  Future<void> deleteMessage(String roomId, List<String> msgs);
}
