import 'package:meetup/services/ai.service.dart';

class AppStrings {
  static String appName = "MeetUp";
  static String companyName = "EdenTech";

  //for app usage
  static String firstTimeOnApp = "first_time";
  static String authenticated = "authenticated";
  static String userAuthToken = "auth_token";
  static String userKey = "user";
  static String appLocale = "locale";
  static String appAd = "app_ad";
  static String notificationsKey = "notifications";

  //Change to your app store id
  static String appStoreId = "";

  static String get meetingPrefixID {
    return ApiService().getAppSettings()['meeting_prefix_id'] ?? "";
  }
}
