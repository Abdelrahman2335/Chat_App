

import '../../../data/models/group_model.dart';
import '../../../data/models/room_model.dart';

abstract class GroupHomeRepo {
  Future<void> createGroup(String email);

  Stream<List<GroupRoom>> getUserGroups();

  Stream<GroupRoom> groupCard(ChatRoom room);

}
