import 'dart:async';

import 'package:chat_app/models/group_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

///class named FireData
class FireData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  final String now = DateTime.now().millisecondsSinceEpoch.toString();

  ///anythings in this class named method
  Future createRoom(String email) async {
    QuerySnapshot userEmail = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    if (userEmail.docs.isNotEmpty) {
      String userId = userEmail.docs.first.id;
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
          createdAt: now,
          lastMessage: "",
          members: members,
          lastMessageTime: now,
        );
        await firestore.collection("rooms").doc(members.toString()).set(
              /// we write this peace of code to create collection named "rooms" and inside it we have doc inside it (members).
              chatdata.tojson(),
            );
      } else {
        return Container();
      }
    }
  }

  Future creatGroup(String name,List members) async {
    String gId = const Uuid().v6();
    members.add(myUid);
    GroupRoom groupRoom = GroupRoom(
        id: gId,
        name: name,
        admin: [myUid],
        image: "",
        createdAt: now,
        members: members,
        lastMessage: "",
        lastMessageTime: now);
    await firestore.collection("groups").doc(gId).set(groupRoom.toJson());

  }

  Future creatContacts(String email) async {
    QuerySnapshot userEmail = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    if (userEmail.docs.isNotEmpty) {
      String userId = userEmail.docs.first.id;
      firestore.collection("users").doc(myUid).update({
        "my_users": FieldValue.arrayUnion([userId])

        ///note that my_users is exist and you can add contacts normally,
        /// but if it was empty(have no data) you will not see it on the firebase
      });
    }
  }

  Future sendMessage(String uid, String msg, String roomId,
      {String? type}) async {
    String msgId = const Uuid().v6();
    Message message = Message(
        id: msgId,
        toId: uid,
        fromId: myUid,
        msg: msg,
        type: type ?? "text",
        createdAt: now,
        read: "");
    await firestore
        .collection("rooms")
        .doc(roomId)
        .collection("messages")
        .doc(msgId)
        .set(
          message.tojson(),
        );

    ///this set is Future so we have to await so we have to use async and also we will make sendMessage Future
    await firestore.collection("rooms").doc(roomId).update({
      "lastMessage": type ?? msg,
      "lastMessageTime": now
    });
  }

  Future sendGMessage( String msg, String groupId,
      {String? type}) async {
    String msgId = const Uuid().v6();
    Message message = Message(
        id: msgId,
        toId: "",
        fromId: myUid,
        msg: msg,
        type: type ?? "text",
        createdAt: now,
        read: "");
    await firestore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .doc(msgId)
        .set(
          message.tojson(),
        );

    ///this set is Future so we have to await so we have to use async and also we will make sendMessage Future
    await firestore.collection("groups").doc(groupId).update({
      "lastMessage": type ?? msg,
      "lastMessageTime": now
    });
  }

  Future readMessage(String roomId, String msgId) async {
    await firestore
        .collection("rooms")
        .doc(roomId)
        .collection("messages")
        .doc(msgId)
        .update({"read": now});
  }
    deleteMsg(String roomId, List<String> msgs)async{
    for (var element in msgs){
     await firestore.collection("rooms").doc(roomId).collection("messages").doc(element).delete();
      /// so we can't use msgs directly in the doc because this list and doc will not find list he will find only string
    }
  }

  Future editGroup(String gId, String name, List members) async {
    await firestore
        .collection("groups")
        .doc(gId)
        .update({"name": name, "members": FieldValue.arrayUnion(members)});
  }

  Future removeMember(String gId, memberId) async {
    await firestore.collection("groups").doc(gId).update({
      "members": FieldValue.arrayRemove([memberId])
    });
  }

  Future promptAdmin(String gId, memberId) async {
    await firestore.collection("groups").doc(gId).update({
      "admin": FieldValue.arrayUnion([memberId])
    });
  }

  Future removeAdmin(String gId, memberId) async {
    await firestore.collection("groups").doc(gId).update({
      "admin": FieldValue.arrayRemove([memberId])
    });
  }
}
