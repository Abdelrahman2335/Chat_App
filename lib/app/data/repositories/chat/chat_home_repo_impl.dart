import 'dart:developer';

import 'package:chat_app/app/core/services/firebase_service.dart';
import 'package:chat_app/app/data/models/room_model.dart';
import 'package:chat_app/app/data/models/user_model.dart';
import 'package:chat_app/app/domain/repositories/chat_room/chat_home_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'chat_home_repo_impl.g.dart';

class ChatHomeRepoImpl implements ChatHomeRepo {
  final FirebaseService _firebaseService = FirebaseService();
  final String currentDate = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Future<void> createRoom(String email) async {
    if (email == _firebaseService.auth.currentUser!.email) {
      throw Exception("You can't chat with yourself");
    }
    try {
      final userEmail = await _firebaseService.firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();
      if (userEmail.docs.isNotEmpty) {
        String userId = userEmail.docs.first.id;
        List<String> members = [
          _firebaseService.auth.currentUser!.uid,
          userId,
        ]..sort(
            (user1, user2) => user1.compareTo(user2),

            /// Here we are sorting the users ID
          );
        final roomId = members.join("_").toString();
        final roomExist = await _firebaseService.firestore
            .collection("rooms")
            .doc(roomId)
            .get();
        if (!roomExist.exists) {
          /// Check if the room is exist or not if not we will do the follow if yes we will let the user go to the chat.
          ChatRoom createChat = ChatRoom(
            id: roomId,
            createdAt: currentDate,
            lastMessage: "",
            members: members,
            lastMessageTime: currentDate,
          );
          await _firebaseService.firestore.collection("rooms").doc(roomId).set(
                /// we write this peace of code to create collection named "rooms" and inside it we have doc inside it (members).
                createChat.toJson(),
              );
        } else {
          throw Exception("Room already exist");
        }
      } else {
        throw Exception("Email not exist");
      }
    } catch (error) {
      log("Error in the createChat method $error");
      rethrow;
    }
  }

  @override
  Stream<List<ChatRoom>> getUserChatRooms() {
    try {
      final uid = _firebaseService.auth.currentUser!.uid;
      return _firebaseService.firestore
          .collection("rooms")
          .where("members", arrayContains: uid)
          .snapshots()
          .map((snapshot) {
        final List<ChatRoom> rooms =
            snapshot.docs.map((doc) => ChatRoom.fromJson(doc.data())).toList();
        rooms.sort(
          (a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),
        );
        return rooms;
      });
    } catch (error) {
      log("Error in the getUserChatRooms method $error");
      rethrow;
    }
  }

  @override
  Stream<UserModel> chatCard(ChatRoom room) {
    try {
      /// this is not current user id this is his friend id
      String friendId = room.members!
          .where((element) => element != _firebaseService.auth.currentUser!.uid)
          .first;
      return _firebaseService.firestore
          .collection("users")
          .doc(friendId)
          .snapshots()
          .map((snapshot) {
        final data = UserModel.fromJson(snapshot.data()!);
        return data;
      });
    } catch (error) {
      log("Error in the chatCard method $error");
      rethrow;
    }
  }


}

@riverpod
ChatHomeRepo chatRepo(ref) {
  return ChatHomeRepoImpl();
}
