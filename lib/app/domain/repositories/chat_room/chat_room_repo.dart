import 'dart:io';

import '../../../data/models/message_model.dart';

abstract class ChatRoomRepo {
  Stream<List<Message>> getMessages(String roomId);

  Future<void> sendMessage(Message message, String roomId);

  Future<void> sendImage(
     File file,
     String roomId,
     String? currentId,
     String toId,
  );
}
