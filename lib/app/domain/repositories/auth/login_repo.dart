abstract class LoginRepo {
  Future<void> createUser(String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();
}
