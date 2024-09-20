import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:meetup/models/ad.dart';
import 'package:meetup/services/auth.service.dart';

class AdmobService {
  //
  static Ad? ad;
  static initialize() async {
    //getting ad settings
    ad = AuthServices.getAd();
  }

  //
  static String? get appID {
    //

    if (Platform.isAndroid) {
      return ad?.android?.appId;
    } else {
      return ad?.ios?.appId;
    }
  }

  static String get adUnitID {
    //load ad only on release mode, to avoid been banned by admob
    if (!kReleaseMode) {
      return testAdUnitId;
    }

    if (Platform.isAndroid) {
      return ad?.android?.bannerAdId ?? testAdUnitId;
    } else {
      return ad?.ios?.bannerAdId ?? testAdUnitId;
    }
  }

  //get text ad unit id
  static String get testAdUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
  }
}
