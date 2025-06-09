import 'dart:io';

import 'package:chat_app/app/data/models/user_model.dart';

import '../../../data/models/message_model.dart';

abstract class GroupRoomRepo {

  Stream<List<Message>> getGroupMessages(String groupId);

  Future<List<UserModel>> getGroupMembers(List<String> members);

  Future<void> sendGroupMessage(Message message, String groupId);

  Future<void> sendGroupImage(
      File file,
      String groupId,
      String? currentId,
      String toId,
      );

}