import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_languages.dart';
import 'package:meetup/my_app.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/services/firebase.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //check if user has signin before
  await AuthServices.getPrefs();
  await Firebase.initializeApp();
  //setting up firebase notifications
  await FirebaseService.setUpFirebaseMessaging();
  await MobileAds.instance.initialize();
  //
  await translator.init(
    localeType: LocalizationDefaultType.asDefined,
    languagesList: AppLanguages.codes,
    assetsDirectory: 'assets/lang/',
  );

  // Run app!
  runApp(
    LocalizedApp(
      child: const MyApp(),
    ),
  );
}
