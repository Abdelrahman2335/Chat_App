import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/app/domain/repositories/auth/login_repo.dart';

import '../../../data/repositories/auth/login_repo_impl.dart';

class LoginController extends AsyncNotifier<void> {
  late final LoginRepo _loginRepo;

  @override
  Future<void> build() async {
    _loginRepo = ref.watch(loginRepoProvider);
  }

  Future<void> createUser(String email, String password) async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => _loginRepo.createUser(email, password));
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loginRepo.login(email, password));
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loginRepo.logout());
  }
}
final loginControllerProvider =
AsyncNotifierProvider<LoginController, void>(() => LoginController());
