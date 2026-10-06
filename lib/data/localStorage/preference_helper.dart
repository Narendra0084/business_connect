import 'dart:convert';

import 'package:bihar_business_connect/features/auth/domain/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static const String loginUser = 'login_user';

  static final PreferenceHelper _instance =
  PreferenceHelper._internal();

  PreferenceHelper._internal();

  static PreferenceHelper get instance => _instance;

  SharedPreferences? _preferences;

  Future<SharedPreferences> getSharedPrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // ============================================================
  // SAVE USER
  // ============================================================

  Future<bool> saveUserInformation(AppUser user) async {
    try {
      final prefs = await getSharedPrefs();

      final Map<String, dynamic> userMap = user.toLocalMap();

      final String userJson = jsonEncode(userMap);

      final bool saved = await prefs.setString(
        loginUser,
        userJson,
      );

      print('========== SAVE LOCAL USER ==========');
      print('Saved: $saved');
      print('JSON: $userJson');
      print('=====================================');

      return saved;
    } catch (e) {
      print('SAVE LOCAL USER ERROR: $e');
      return false;
    }
  }

  // ============================================================
  // GET USER
  // ============================================================

  Future<AppUser?> getUserInformation() async {
    try {
      final prefs = await getSharedPrefs();

      final String? userJson = prefs.getString(loginUser);

      print('========== GET LOCAL USER ==========');
      print('JSON: $userJson');
      print('====================================');

      if (userJson == null || userJson.isEmpty) {
        return null;
      }

      final Map<String, dynamic> userMap =
      jsonDecode(userJson) as Map<String, dynamic>;

      return AppUser.fromLocalMap(userMap);
    } catch (e) {
      print('GET LOCAL USER ERROR: $e');
      return null;
    }
  }

  // ============================================================
  // REMOVE USER
  // ============================================================

  Future<bool> clearUserInformation() async {
    final prefs = await getSharedPrefs();

    final result = await prefs.remove(loginUser);

    print('Local user removed: $result');

    return result;
  }

  // ============================================================
  // CHECK USER EXISTS
  // ============================================================

  Future<bool> hasUserInformation() async {
    final prefs = await getSharedPrefs();

    return prefs.containsKey(loginUser);
  }
}