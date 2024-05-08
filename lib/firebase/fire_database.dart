
import 'package:chat_app/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
 Future createRoom(String email) async {
    QuerySnapshot userEmail = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    String userId = userEmail.docs.first.id;
    if(userEmail.docs.isNotEmpty){
    List<String> members = [
      myUid,
      userId,
    ]..sort(
        (user1, user2) => user1.compareTo(user2),

        /// Here we are sorting the users ID
      );
    QuerySnapshot roomExist = await firestore
        .collection("rooms")
        .where("members", isEqualTo: members)
        .get();
    if (roomExist.docs.isEmpty) {
      /// Check if the room is exist or not if not we will do the follow if yes we will let the user go to the chat or the room
      ChatRoom chatdata = ChatRoom(
        id: members.toString(),
        createdAt: DateTime.now().toString(),
      lastMessage: "",
      members: members,
      lastMessageTime: DateTime.now().toString(),
    );
    await firestore.collection("rooms").doc(members.toString()).set(
          /// we write this peace of code to create collection named "rooms" and inside it we have doc inside it (members).
          chatdata.tojson(),
        );
    }
  }}
}