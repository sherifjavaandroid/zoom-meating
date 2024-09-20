import 'dart:convert';
import 'package:meetup/services/auth.service.dart';
import 'package:singleton/singleton.dart';

class ApiService {
  //ENUM for pref AI_SETTINGS
  static String aiSettings = "ai";
  static String appKeySettings = "app_settings";

  /// Factory method that reuse same instance automatically
  factory ApiService() => Singleton.lazy(() => ApiService._());

  /// Private constructor
  ApiService._();

  //save ai app settings json
  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    return await AuthServices.prefs!
        .setString(appKeySettings, jsonEncode(settings));
  }

  //fetch ai app settings json
  Map<String, dynamic> getAppSettings() {
    return jsonDecode(AuthServices.prefs!.getString(appKeySettings) ?? "{}");
  }

  //fetch ai app settings json
  Map<String, dynamic> getAIAppSettings() {
    return jsonDecode(
            AuthServices.prefs!.getString(appKeySettings) ?? "{}")['ai'] ??
        {};
  }

  //getters
  bool get isAIChatEnabled {
    return getAIAppSettings()["chatbot"] ?? false;
  }

  bool get isAIImageGenerationEnabled {
    return getAIAppSettings()["image_generation"] ?? false;
  }

  bool get isAIAuthRequired {
    return getAIAppSettings()["auth_required"] ?? true;
  }
}
