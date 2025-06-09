

import '../../../data/models/group_model.dart';

abstract class GroupHomeRepo {
  Future<void> createGroup(String name, List members);

  Stream<List<GroupRoom>> getUserGroups();

}
