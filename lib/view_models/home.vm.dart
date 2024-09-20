// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetup/services/admob.service.dart';
import 'package:meetup/view_models/base.view_model.dart';

class HomeViewModel extends MyBaseViewModel {
  //
  HomeViewModel(BuildContext context) {
    viewContext = context;
  }

  //
  int currentIndex = 1;

  //
  bool adLoaded = false;
  BannerAd? myBanner;

  PageController pageViewController = PageController(initialPage: 1);

  //
  @override
  initialise() {
    loadBanner();
  }

  //
  onPageChanged(int index) {
    currentIndex = index;

    if (index != 3) {
      loadBanner();
    } else {
      closeBanner();
    }
    notifyListeners();
  }

  //
  onTabChange(int index) {
    currentIndex = index;
    pageViewController.animateToPage(
      currentIndex,
      duration: const Duration(microseconds: 5),
      curve: Curves.bounceInOut,
    );
    notifyListeners();
  }

  //
  initiateAd() async {
    myBanner = BannerAd(
      adUnitId: AdmobService.adUnitID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        if (kDebugMode) {
          print("Ad loaded ==> $ad");
        }
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        if (kDebugMode) {
          print("Ad onAdFailedToLoad ==> $ad");
        }
      }),
    );
    // myBanner = BannerAd(
    //   adUnitId: AdmobService.adUnitID ?? BannerAd.testAdUnitId,
    //   size: AdSize.banner,
    //   listener: (MobileAdEvent event) {
    //     print("BannerAd event is $event");
    //   },
    // );
  }

  //
  loadBanner() {
    //

    //
    if (!adLoaded) {
      initiateAd();
      myBanner?.load();
      adLoaded = true;
    }
  }

  //
  closeBanner() {
    if (adLoaded) {
      myBanner?.dispose();
      adLoaded = false;
    }
  }
}
