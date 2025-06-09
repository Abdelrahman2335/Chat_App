import '../../../data/models/user_model.dart';

abstract class ContactHomeRepo {
  Future<List<UserModel>> getContacts();

  Future<void> addContact(String email);
}