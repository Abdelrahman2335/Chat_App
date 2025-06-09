import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/group_model.dart';
import '../../../data/repositories/group_room/group_home_repo_Impl.dart';

part 'group_home_provider.g.dart';

@riverpod
Stream<List<GroupRoom>> groupRooms(ref) {
  final repository = ref.watch(groupHomeRepoImplProvider);
  return repository.getUserGroups();
}
