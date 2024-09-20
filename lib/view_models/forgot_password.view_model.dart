import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/requests/auth.request.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetup/widgets/bottomsheets/account_verification_entry.dart';
import 'package:meetup/widgets/bottomsheets/new_password_entry.dart';
import 'package:stacked/stacked.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPasswordViewModel extends MyBaseViewModel {
  //the textediting controllers
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  final AuthRequest _authRequest = AuthRequest();
  FirebaseAuth auth = FirebaseAuth.instance;

  //
  String? firebaseToken;

  ForgotPasswordViewModel(BuildContext context) {
    viewContext = context;
  }

  //initiate the otp sending to provided phone
  processForgotPassword() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      //

      setBusy(true);

      //
      //firebase authentication
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneTEC.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          //
          UserCredential userCredential = await auth.signInWithCredential(
            credential,
          );

          //fetch user id token
          firebaseToken = await userCredential.user!.getIdToken();
          firebaseVerificationId = credential.verificationId;

          //
          showNewPasswordEntry();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            viewContext!.showToast(msg: "Invalid Phone Number".tr());
          } else {
            viewContext!.showToast(msg: e.message!);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          firebaseVerificationId = verificationId;
          showVerificationEntry();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          //
          firebaseVerificationId = verificationId;
          showVerificationEntry();
        },
      );
      setBusy(false);
    }
  }

  //show a bottomsheet to the user for verification code entry
  void showVerificationEntry() {
    //
    showModalBottomSheet(
      context: viewContext!,
      isScrollControlled: true,
      builder: (context) {
        return AccountVerificationEntry(
          vm: this,
          onSubmit: (smsCode) {
            //
            verifyFirebaseOTP(smsCode);
          },
        );
      },
    );
  }

  //verify the provided code with the firebase server
  void verifyFirebaseOTP(String smsCode) async {
    //
    setBusyForObject(firebaseVerificationId, true);

    // Sign the user in (or link) with the credential
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseVerificationId!,
        smsCode: smsCode,
      );

      UserCredential userCredential = await auth.signInWithCredential(
        phoneAuthCredential,
      );
      //
      firebaseToken = await userCredential.user?.getIdToken();

      viewContext!.popRoute();
      showNewPasswordEntry();
    } catch (error) {
      viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(firebaseVerificationId, false);
  }

  //show a bottomsheet to the user for verification code entry
  showNewPasswordEntry() {
    //
    showModalBottomSheet(
      context: viewContext!,
      isScrollControlled: true,
      builder: (context) {
        return NewPasswordEntry(
          vm: this,
          onSubmit: (password) {
            //
            finishChangeAccountPassword();
          },
        );
      },
    );
  }

  //
  finishChangeAccountPassword() async {
    //

    setBusy(true);
    final apiResponse = await _authRequest.resetPasswordRequest(
      phone: phoneTEC.text,
      password: passwordTEC.text,
      firebaseToken: firebaseToken!,
    );
    setBusy(false);

    CoolAlert.show(
      context: viewContext!,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Forgot Password".tr(),
      text: apiResponse.message,
      onConfirmBtnTap: apiResponse.allGood
          ? () {
              viewContext!.navigator!.popUntil((route) => route.isFirst);
            }
          : null,
    );
  }
}
