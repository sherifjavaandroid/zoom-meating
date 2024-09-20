import 'dart:convert';

import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/models/notification.dart';
import 'package:meetup/services/auth.service.dart';

class NotificationService {
  //
  static Future<List<NotificationModel>> getNotifications() async {
    //
    final notificationsStringList = AuthServices.prefs?.getString(
      AppStrings.notificationsKey,
    );

    if (notificationsStringList == null) {
      return [];
    }

    return (jsonDecode(notificationsStringList) as List)
        .asMap()
        .entries
        .map((notificationObject) {
      //
      return NotificationModel(
        index: notificationObject.key,
        title: notificationObject.value["title"],
        body: notificationObject.value["body"],
        timeStamp: notificationObject.value["timeStamp"],
      );
    }).toList();
  }

  static void addNotification(NotificationModel notification) async {
    //
    final notifications = await getNotifications();
    notifications.add(notification);

    //
    await AuthServices.prefs?.setString(
      AppStrings.notificationsKey,
      jsonEncode(notifications),
    );
  }

  static void updateNotification(NotificationModel notificationModel) async {
    //
    final notifications = await getNotifications();
    notifications.removeAt(notificationModel.index ?? 0);
    notifications.insert(notificationModel.index ?? 0, notificationModel);
    await AuthServices.prefs?.setString(
      AppStrings.notificationsKey,
      jsonEncode(notifications),
    );
  }
}
