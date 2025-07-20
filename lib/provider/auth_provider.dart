import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/utils/hive_utils.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(HiveUtils.isLoggedIn());

  Future<void> login(String userId) async {
    await HiveUtils.setLoggedIn(true, userId: userId);
    state = true;
  }

  Future<void> logout() async {
    await HiveUtils.clearAuthData();
    state = false;
  }
}
