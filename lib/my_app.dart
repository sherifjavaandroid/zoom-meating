import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/services/app.service.dart';
import 'package:meetup/views/pages/splash.page.dart';
import 'package:meetup/services/router.service.dart' as router;

import 'constants/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlexSchemeData _myFlexScheme = const FlexSchemeData(
      name: 'Base Theme',
      description: 'Midnight blue theme, custom definition of all colors',
      light: FlexSchemeColor(
        primary: AppColor.primaryColor,
        secondary: AppColor.accentColor,
        primaryContainer: AppColor.primaryColorDark,
        secondaryContainer: AppColor.accentColor,
      ),
      dark: FlexSchemeColor(
        primary: AppColor.primaryColor,
        secondary: AppColor.accentColor,
        primaryContainer: AppColor.primaryColorDark,
        secondaryContainer: AppColor.accentColor,
      ),
    );

    //
    return MaterialApp(
      navigatorKey: AppService().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      onGenerateRoute: router.generateRoute,
      // initialRoute: _startRoute,
      localizationsDelegates: translator.delegates,
      locale: translator.activeLocale,
      supportedLocales: translator.locals(),
      home: const SplashPage(),
      theme: FlexThemeData.light(
        colors: _myFlexScheme.light,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ).copyWith(
        brightness: Brightness.light,
      ),
      // Same setup for the dark theme, but using FlexThemeData.dark().
      darkTheme: FlexThemeData.dark(
        colors: _myFlexScheme.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ).copyWith(
        brightness: Brightness.dark,
      ),
    );
  }
}
