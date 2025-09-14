import 'dart:developer';

import 'package:chat_app/app/domain/repositories/group/group_home_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/firebase_service.dart';
import '../../models/group_model.dart';
part 'group_home_repo_impl.g.dart';

class GroupHomeRepoImpl implements GroupHomeRepo {
  final FirebaseService _firebaseService = FirebaseService();
  final String currentDate = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Future<void> createGroup(String name, List<String> members) async {
    try {
      members.add(_firebaseService.auth.currentUser!.uid);
      GroupRoom groupRoom = GroupRoom(
          name: name,
          admin: [_firebaseService.auth.currentUser!.uid],
          image: "",
          createdAt: currentDate,
          members: members,
          lastMessage: "",
          lastMessageTime: "");
      await _firebaseService.firestore
          .collection("groups")
          .doc(groupRoom.id)
          .set(groupRoom.toJson());
    } catch (error) {
      log("Error in the createGroup method $error");
      rethrow;
    }
  }

  @override
  Stream<List<GroupRoom>> getUserGroups() {
    try {
      final uid = _firebaseService.auth.currentUser!.uid;
      return _firebaseService.firestore
          .collection("groups")
          .where("members", arrayContains: uid)
          .snapshots()
          .map((snapshot) {
        final List<GroupRoom> groups =
            snapshot.docs.map((doc) => GroupRoom.fromJson(doc.data())).toList();
        groups.sort(
          (a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),
        );
        return groups;
      });
    } catch (error) {
      log("Error in the getUserChatRooms method $error");
      rethrow;
    }
  }
}

//TODO: implement unread messages
//   @override
//   Stream<List<Message>> groupCard(GroupRoom room) {
// }

@riverpod
GroupHomeRepo groupHomeRepoImpl(Ref ref) {
  return GroupHomeRepoImpl();
}
