import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/utils/hive_utils.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  StreamSubscription<User?>? _authSub;

  AuthNotifier() : super(HiveUtils.isLoggedIn()) {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        await HiveUtils.clearAuthData();
        state = false;
      } else {
        await HiveUtils.setLoggedIn(true, userId: user.uid);
        state = true;
      }
    });
  }

  Future<void> login(String userId) async {
    await HiveUtils.setLoggedIn(true, userId: userId);
    state = true;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await HiveUtils.clearAuthData();
    state = false;
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
