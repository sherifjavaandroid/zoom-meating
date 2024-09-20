import 'package:flutter/material.dart';
import 'package:meetup/constants/app_routes.dart';
import 'package:meetup/models/notification.dart';
import 'package:meetup/views/pages/auth/forgot_password.page.dart';
import 'package:meetup/views/pages/auth/login.page.dart';
import 'package:meetup/views/pages/auth/register.page.dart';
import 'package:meetup/views/pages/edit_profile.page.dart';
import 'package:meetup/views/pages/home.page.dart';
import 'package:meetup/views/pages/notification_details.page.dart';
import 'package:meetup/views/pages/notifications.page.dart';
import 'package:meetup/views/pages/onboarding.page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => const OnboardingPage());

    case AppRoutes.loginRoute:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case AppRoutes.registerRoute:
      return MaterialPageRoute(builder: (context) => const RegisterPage());

    case AppRoutes.forgotPasswordRoute:
      return MaterialPageRoute(
          builder: (context) => const ForgotPasswordPage());

    case AppRoutes.homeRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.homeRoute, arguments: {}),
        builder: (context) => const HomePage(),
      );

    //
    case AppRoutes.editProfileRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.editProfileRoute),
        builder: (context) => const EditProfilePage(),
      );

    //
    case AppRoutes.notificationsRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(
            name: AppRoutes.notificationsRoute, arguments: {}),
        builder: (context) => const NotificationsPage(),
      );

    //
    case AppRoutes.notificationDetailsRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(
            name: AppRoutes.notificationDetailsRoute, arguments: {}),
        builder: (context) => NotificationDetailsPage(
          notification: settings.arguments as NotificationModel,
        ),
      );

    default:
      return MaterialPageRoute(builder: (context) => const OnboardingPage());
  }
}
