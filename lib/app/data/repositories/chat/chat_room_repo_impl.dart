import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/data/models/message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/repositories/chat_room_repo.dart';

part 'chat_room_repo_impl.g.dart';


class ChatRoomImpl implements ChatRoomRepo {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Stream<List<Message>> getMessages(String roomId) {
    return _firebaseService.firestore
        .collection("rooms")
        .doc(roomId)
        .collection("messages")
        .snapshots()
        .map((event) {
      final message =
          event.docs.map((msg) => Message.fromJson(msg.data())).toList();
      return message;
    });
  }
}

@riverpod
ChatRoomRepo chatRoomRepo(ref) {
  return ChatRoomImpl();
}
