import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

///class named FireData
class FireData {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  final String now = DateTime.now().millisecondsSinceEpoch.toString();



  Future readMessage(String roomId, List<String> msgId) async {
    for (String element in msgId) {
      await fireStore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .doc(element)
          .update({"read": now});
    }
  }

  deleteMsg(String roomId, List<String> msgs) async {
    for (var element in msgs) {
      await fireStore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .doc(element)
          .delete();

      /// so we can't use msgs directly in the doc because this list and doc will not find list he will find only string
    }
  }

  Future editGroup(String gId, String name, List members) async {
    await fireStore
        .collection("groups")
        .doc(gId)
        .update({"name": name, "members": FieldValue.arrayUnion(members)});
  }

  Future removeMember(String gId, memberId) async {
    await fireStore.collection("groups").doc(gId).update({
      "members": FieldValue.arrayRemove([memberId])
    });
  }

  Future promptAdmin(String gId, memberId) async {
    await fireStore.collection("groups").doc(gId).update({
      "admin": FieldValue.arrayUnion([memberId])
    });
  }

  Future removeAdmin(String gId, memberId) async {
    await fireStore.collection("groups").doc(gId).update({
      "admin": FieldValue.arrayRemove([memberId])
    });
  }

  Future editProfile(String name, String about) async {
    await fireStore
        .collection("users")
        .doc(myUid)
        .update({"name": name, "about": about});
  }

  sendNotification(
      {required UserModel chatUser,
      required BuildContext context,
      required String msg}) async {}
}
