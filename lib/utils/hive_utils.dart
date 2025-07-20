import 'package:hive_flutter/hive_flutter.dart';

class HiveUtils {
  static const String authBoxName = 'authBox';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userIdKey = 'userId';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(authBoxName);
  }

  static Future<void> setLoggedIn(bool value, {String? userId}) async {
    final box = Hive.box(authBoxName);
    await box.put(isLoggedInKey, value);
    if (userId != null) {
      await box.put(userIdKey, userId);
    }
  }

  static bool isLoggedIn() {
    final box = Hive.box(authBoxName);
    return box.get(isLoggedInKey, defaultValue: false) as bool;
  }

  static String? getUserId() {
    final box = Hive.box(authBoxName);
    return box.get(userIdKey) as String?;
  }

  static Future<void> clearAuthData() async {
    final box = Hive.box(authBoxName);
    await box.clear();
  }
}
