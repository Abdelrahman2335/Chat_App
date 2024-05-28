import 'dart:io';

import 'package:chat_app/firebase/fire_database.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

/// Note that you may cannot use fire storage to store files or images if you debugging on web(Chrome)
/// but it will work fine on emulator or phone
class FireStorage {
  final FirebaseStorage fireStorage = FirebaseStorage.instance;

  ///this line is used to get just the extension so we use it later
  sendImage(
      {required File file,
      required String roomId,
      required String uid,
      required ChatUser chatUser,
      required BuildContext context}) async {
    String ext = file.path.split(".").last;

    /// reference in Flutter is used to store things like images in specific locations in the Firebase Storage
    final ref = fireStorage
        .ref()
        .child("images/$roomId/${DateTime.now().millisecondsSinceEpoch}.$ext");

    ///here we are taking the file and uploading it to the firestore in the ref location that he told us about.
    await ref.putFile(file);

    ///this line knows where is the file is stored so we can use it later in any part of the project
    String imageUrl = await ref.getDownloadURL();

    FireData()
        .sendMessage(uid, imageUrl, roomId, context, type: "image", chatUser);
  }

  Future profileImage({
    required File file,
  }) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String ext = file.path.split(".").last;

    /// reference in Flutter is used to store things like images in specific locations in the Firebase Storage
    final ref = fireStorage
        .ref()
        .child("profile/$uid/${DateTime.now().millisecondsSinceEpoch}.$ext");

    ///here we are taking the file and uploading it to the firestore in the ref location that he told us about.
    await ref.putFile(file);

    ///this line knows where is the file is stored so we can use it later in any part of the project
    String imageUrl = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"image": imageUrl});
  }
}
