import 'package:bihar_business_connect/data/localStorage/preference_helper.dart';
import 'package:bihar_business_connect/features/auth/domain/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class Utilities {
  static AppUser? loginInformation;

  static Future<bool> saveLoginInformation(AppUser user) async {
    final saved = await PreferenceHelper.instance.saveUserInformation(user);

    if (saved) {
      loginInformation = user;
    }

    return saved;
  }

  static Future<AppUser?> getLoginInformation() async {
    // First check memory
    if (loginInformation != null) {
      return loginInformation;
    }

    // Then check SharedPreferences
    final user = await PreferenceHelper.instance.getUserInformation();

    loginInformation = user;

    return user;
  }

  static Future<void> clearLoginInformation() async {
    loginInformation = null;

    await PreferenceHelper.instance.clearUserInformation();
  }

  static void showSnackBar(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    final years = difference.inDays ~/ 365;
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}
