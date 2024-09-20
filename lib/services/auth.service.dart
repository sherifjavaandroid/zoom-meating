import 'dart:convert';

import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/models/ad.dart';
import 'package:meetup/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static SharedPreferences? prefs;
  static Future<SharedPreferences?> getPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
    // prefs.clear();
    return prefs;
  }

  //
  static bool firstTimeOnApp() {
    return prefs?.getBool(AppStrings.firstTimeOnApp) ?? true;
  }

  static Future<bool?> doneFirstTimeOnApp() async {
    return await prefs?.setBool(AppStrings.firstTimeOnApp, false);
  }

  //
  static bool authenticated() {
    return prefs?.getBool(AppStrings.authenticated) ?? false;
  }

  static Future<bool?> isAuthenticated() async {
    return prefs?.setBool(AppStrings.authenticated, true);
  }

  // Token
  static Future<String> getAuthBearerToken() async {
    return prefs?.getString(AppStrings.userAuthToken) ?? "";
  }

  static Future<bool?> setAuthBearerToken(token) async {
    return prefs?.setString(AppStrings.userAuthToken, token);
  }

  //Locale
  static String getLocale() {
    return prefs?.getString(AppStrings.appLocale) ?? "en";
  }

  static Future<bool?> setLocale(language) async {
    return prefs?.setString(AppStrings.appLocale, language);
  }

  //Ad
  static Ad getAd() {
    return Ad.fromRawJson(prefs?.getString(AppStrings.appAd) ?? "{}");
  }

  static Future<bool?> setAd(Ad ad) async {
    return prefs?.setString(AppStrings.appAd, ad.toRawJson());
  }

  //
  //
  static User? currentUser;
  static Future<User> getCurrentUser({bool force = false}) async {
    if (currentUser == null || force) {
      final userStringObject = prefs?.getString(AppStrings.userKey);
      final userObject = json.decode(userStringObject!);
      currentUser = User.fromJson(userObject);
    }
    return currentUser!;
  }

  ///
  ///
  ///
  static Future<User?> saveUser(dynamic jsonObject) async {
    final currentUser = User.fromJson(jsonObject);
    try {
      await prefs?.setString(
        AppStrings.userKey,
        json.encode(
          currentUser.toJson(),
        ),
      );
      return currentUser;
    } catch (error) {
      return null;
    }
  }

  ///
  ///
  //
  static Future<void> logout() async {
    await prefs?.clear();
    await prefs?.setBool(AppStrings.firstTimeOnApp, false);
  }
}
