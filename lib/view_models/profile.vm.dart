import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/api.dart';
import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/extensions/buildcontext.dart';
import 'package:meetup/models/user.dart';
import 'package:meetup/requests/auth.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/view_models/base.view_model.dart';
import 'package:meetup/views/pages/auth/login.page.dart';
import 'package:meetup/views/pages/edit_profile.page.dart';
import 'package:meetup/views/pages/home.page.dart';
import 'package:meetup/views/pages/notifications.page.dart';
import 'package:meetup/widgets/cards/language_selector.view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileViewModel extends MyBaseViewModel {
  //
  String appVersionInfo = "";
  bool authenticated = false;
  User? currentUser;

  //
  final AuthRequest _authRequest = AuthRequest();

  ProfileViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  void initialise() async {
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    appVersionInfo = "$versionName($versionCode)";
    authenticated = AuthServices.authenticated();
    if (authenticated) {
      currentUser = await AuthServices.getCurrentUser(force: true);
    }
    notifyListeners();
  }

  /// Edit Profile

  openEditProfile() async {
    final result = await viewContext!.push(
      const EditProfilePage(),
    );

    if (result != null) {
      initialise();
    }
  }

  /// Logout
  logoutPressed() async {
    CoolAlert.show(
      context: viewContext!,
      type: CoolAlertType.confirm,
      title: "Logout".tr(),
      text: "Are you sure you want to logout?".tr(),
      onConfirmBtnTap: () {
        viewContext!.pop();
        processLogout();
      },
    );
  }

  void processLogout() async {
    //
    CoolAlert.show(
      context: viewContext!,
      type: CoolAlertType.loading,
      title: "Logout".tr(),
      text: "Logging out Please wait...".tr(),
      barrierDismissible: false,
    );

    //
    final apiResponse = await _authRequest.logoutRequest();

    //
    viewContext!.pop();

    if (!apiResponse.allGood) {
      //
      CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.error,
        title: "Logout".tr(),
        text: apiResponse.message,
      );
    } else {
      //

      await AuthServices.logout();
      viewContext!.nextAndRemoveUntilPage(const HomePage());
    }
  }

  deleteAccountPressed() {
    CoolAlert.show(
      context: viewContext!,
      type: CoolAlertType.confirm,
      title: "Delete Account".tr(),
      text: "Are you sure you want to delete your account?".tr(),
      onConfirmBtnTap: () {
        viewContext!.pop();
        processAccountDelete();
      },
    );
  }

  void processAccountDelete() async {
    //
    CoolAlert.show(
      context: viewContext!,
      type: CoolAlertType.loading,
      title: "Delete Account".tr(),
      text: "Deleting Account. Please wait...".tr(),
      barrierDismissible: false,
    );

    //
    final apiResponse = await _authRequest.deleteProfileRequest();

    //
    viewContext!.pop();

    if (!apiResponse.allGood) {
      //
      CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.error,
        title: "Delete Account".tr(),
        text: apiResponse.message,
      );
    } else {
      //
      await AuthServices.logout();
      viewContext!.nextAndRemoveUntilPage(const HomePage());
    }
  }

  openNotification() async {
    viewContext!.nextPage(const NotificationsPage());
  }

  /// App Rating & Review
  openReviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    }
  }

  //
  openPrivacyPolicy() async {
    final url = Api.privacyPolicy;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      viewContext!.showToast(
        msg: 'Could not launch $url',
      );
    }
  }

  //
  changeLanguage() async {
    showModalBottomSheet(
      context: viewContext!,
      builder: (context) {
        return const AppLanguageSelector();
      },
    );
  }

  openLogin() async {
    viewContext!.nextPage(const LoginPage());
  }
}
