import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/group_model.dart';
import '../../../data/repositories/group_room/group_home_repo_Impl.dart';

part 'group_home_provider.g.dart';

@riverpod
Stream<List<GroupRoom>> groupRooms(ref) {
  final repository = ref.watch(groupHomeRepoImplProvider);
  return repository.getUserGroups();
}

@riverpod
Future<void> createGroup(
  ref, {
  required String gName,
  required List members,
}) async {
  final repository = ref.read(groupHomeRepoImplProvider);
  await repository.createGroup(gName, members);
}
