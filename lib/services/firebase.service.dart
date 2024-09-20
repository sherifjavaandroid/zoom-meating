import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meetup/constants/app_routes.dart';
import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/models/notification.dart';
import 'package:meetup/services/notification.service.dart';

class FirebaseService {
  static BuildContext? buildContext;
  static NotificationModel? notificationModel;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static setUpFirebaseMessaging() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    //handling the notification process
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    //Request for notification permission
    /*NotificationSettings settings = */
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // settings.authorizationStatus == AuthorizationStatus.authorized

    //subscribing to all topic
    firebaseMessaging.subscribeToTopic("all");

    //
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // print("onMessage: $message");

      //Saving the notification
      notificationModel = NotificationModel();
      notificationModel!.title = message.notification?.title;
      notificationModel!.body = message.notification?.body;
      notificationModel!.timeStamp = DateTime.now().millisecondsSinceEpoch;

      //add to database/shared pref
      NotificationService.addNotification(notificationModel!);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        AppStrings.appName,
        AppStrings.appName,
        channelDescription: '${AppStrings.appName} Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      );
      var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        notificationModel!.title,
        notificationModel!.body,
        platformChannelSpecifics,
      );
    });

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     // print("onMessage: $message");

    //     //Saving the notification
    //     notificationModel = NotificationModel();
    //     notificationModel.title = message["notification"]["title"];
    //     notificationModel.body = message["notification"]["body"];
    //     notificationModel.timeStamp = DateTime.now().millisecondsSinceEpoch;

    //     //add to database/shared pref
    //     NotificationService.addNotification(notificationModel);

    //     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //       AppStrings.appName,
    //       AppStrings.appName,
    //       '${AppStrings.appName} Notification Channel',
    //       importance: Importance.max,
    //       priority: Priority.high,
    //     );
    //     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    //     var platformChannelSpecifics = NotificationDetails(
    //       android: androidPlatformChannelSpecifics,
    //       iOS: iOSPlatformChannelSpecifics,
    //     );
    //     await flutterLocalNotificationsPlugin.show(
    //       0,
    //       notificationModel.title,
    //       notificationModel.body,
    //       platformChannelSpecifics,
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );

    // firebaseMessaging.onIosSettingsRegistered.listen(
    //   (IosNotificationSettings settings) {
    //     print("Settings registered: $settings");
    //   },
    // );
  }

  static Future? selectNotification(String? payload) async {
    await Navigator.pushNamed(
      buildContext!,
      AppRoutes.notificationsRoute,
    );
  }
}
