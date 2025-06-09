import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/contact/contact_home_repo_impl.dart';

part 'contact_home_provider.g.dart';

@riverpod
Future<void> addContact(ref, String email) async {
  final repository = ref.watch(contactHomeRepoProvider);
  return repository.addContact(email);
}

@riverpod
Future<List<UserModel>> getContact(ref) {
  final repository = ref.watch(contactHomeRepoProvider);
  return repository.getContacts();

}


