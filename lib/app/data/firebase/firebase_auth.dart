import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static final User user = auth.currentUser!;

  static Future createUser() async {
    ChatUser chatUser = ChatUser(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      about: "Hi I'm ${user.displayName}",
      image: "",
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      lastSeen: DateTime.now().millisecondsSinceEpoch.toString(),
      pushToken: "",
      online: false,
      myUsers: [""],
    );
    try{
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.tojson());
  }catch(e){
      log(e.toString());
    }
    }

  Future updateToken(String token) async {
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .update({"push_token": token});
  }
  Future updateStatus(bool status)async{
    firebaseFirestore.collection("users").doc(user.uid).update({
      "online": status,
      "last_seen": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}
