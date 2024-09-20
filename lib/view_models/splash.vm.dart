import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/models/ad.dart';
import 'package:meetup/requests/settings.request.dart';
import 'package:meetup/services/admob.service.dart';
import 'package:meetup/services/ai.service.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/view_models/base.view_model.dart';
import 'package:meetup/views/pages/home.page.dart';
import 'package:meetup/views/pages/onboarding.page.dart';
import 'package:meetup/widgets/cards/language_selector.view.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashViewModel extends MyBaseViewModel {
  //
  SplashViewModel(BuildContext context) {
    viewContext = context;
  }

  //
  SettingsRequest settingsRequest = SettingsRequest();

  loadAppSettings() async {
    //initializing admob
    final apiResponse = await settingsRequest.appSettings();
    if (apiResponse.allGood) {
      //save ai values
      await ApiService().saveAppSettings(apiResponse.body ?? {});
      //
      final ad = Ad.fromJson(apiResponse.body["ad"]);

      //incase no ad have been set
      try {
        await AuthServices.setAd(ad);
        await AdmobService.initialize();
      } catch (error) {
        if (kDebugMode) {
          print("Admob error => $error");
        }
      }
      loadNextPage();
    } else {
      viewContext!.showToast(msg: "Please check your internet connection");
    }
  }

  //
  loadNextPage() async {
    //
    await Jiffy.setLocale(translator.activeLanguageCode);
    //
    if (AuthServices.firstTimeOnApp()) {
      //choose language
      await showModalBottomSheet(
        context: viewContext!,
        builder: (context) {
          return const AppLanguageSelector();
        },
      );
      //
      await AuthServices.doneFirstTimeOnApp();
    }

    //
    viewContext!.nextAndRemoveUntilPage(
      AuthServices.firstTimeOnApp() ? const OnboardingPage() : const HomePage(),
    );
  }
}
