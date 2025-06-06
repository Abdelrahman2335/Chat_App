

import '../../data/models/message_model.dart';

abstract class ChatRoomRepo {

  Stream<List<Message>> getMessages(String roomId);

}