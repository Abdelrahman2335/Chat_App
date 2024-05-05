import 'package:chat_app/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;

  createRoom(String email) async {
    QuerySnapshot userEmail = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    String userId = userEmail.docs.first.id;
    List<String> members = [
      myUid,
      userId,
    ];
    ChatRoom chatdata = ChatRoom(
      id: "",
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
}
