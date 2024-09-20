import 'package:flutter/material.dart';
import 'package:singleton/singleton.dart';

class AppService {
  //

  /// Factory method that reuse same instance automatically
  factory AppService() => Singleton.lazy(() => AppService._());

  /// Private constructor
  AppService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
