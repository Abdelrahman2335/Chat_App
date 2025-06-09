import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../models/group_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

///class named FireData
class FireData {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  final String now = DateTime.now().millisecondsSinceEpoch.toString();


  Future creatContacts(String email) async {
    QuerySnapshot userEmail = await fireStore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    log(userEmail.docs.isNotEmpty.toString());
    log(email);
    if (userEmail.docs.isNotEmpty) {
      log("${userEmail.docs.isNotEmpty}");
      String userId = userEmail.docs.first.id;
    await  fireStore.collection("users").doc(myUid).update({
        "my_users": FieldValue.arrayUnion([userId])

        ///note that my_users is exist and you can add contacts normally,
        /// but if it was empty(have no data) you will not see it on the firebase
      });
    }
  }

  Future sendGMessage(
      String msg, String groupId, BuildContext context, GroupRoom chatGroup,
      {String? type}) async {
    List<UserModel> chatUser = [];
    chatGroup.members =
        chatGroup.members!.where((element) => element != myUid).toList();
    fireStore
        .collection("users")
        .where("id", whereIn: chatGroup.members)
        .get()
        .then((value) => chatUser
            .addAll(value.docs.map((e) => UserModel.fromJson(e.data()))));
    String msgId = const Uuid().v6();
    Message message = Message(
        id: msgId,
        toId: "",
        fromId: myUid,
        msg: msg,
        type: type ?? "text",
        createdAt: now,
        read: "");
    await fireStore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .doc(msgId)
        .set(
          message.toJson(),
        )
        .then((value) {
      for (var e in chatUser) {
        sendNotification(
          chatUser: e,
          context: context,
          msg: type ?? msg,
        );
      }
    });

    ///this set is Future so we have to await so we have to use async and also we will make sendMessage Future
    await fireStore
        .collection("groups")
        .doc(groupId)
        .update({"lastMessage": type ?? msg, "lastMessageTime": now});
  }

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
