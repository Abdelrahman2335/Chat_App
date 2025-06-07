import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


/// Note that you may cannot use fire storage to store files or images if you debugging on web(Chrome)
/// but it will work fine on emulator or phone
class FireStorage {
  final FirebaseStorage fireStorage = FirebaseStorage.instance;


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
