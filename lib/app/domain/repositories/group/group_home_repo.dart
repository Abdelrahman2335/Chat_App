import '../../../data/models/group_model.dart';

abstract class GroupHomeRepo {
  Future<void> createGroup(String name, List<String> members);

  Stream<List<GroupRoom>> getUserGroups();

  // Stream<Message> groupCard(GroupRoom room);
}
