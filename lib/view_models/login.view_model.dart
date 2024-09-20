import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/requests/auth.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/views/pages/auth/forgot_password.page.dart';
import 'package:meetup/views/pages/auth/register.page.dart';
import 'package:meetup/views/pages/home.page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'base.view_model.dart';

class LoginViewModel extends MyBaseViewModel {
  //the textediting controllers
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  //
  final AuthRequest _authRequest = AuthRequest();

  LoginViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  void initialise() {
    //
    emailTEC.text = "subscriber@demo.com";
    passwordTEC.text = "password";
  }

  void processLogin() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      //

      setBusy(true);

      final apiResponse = await _authRequest.loginRequest(
        email: emailTEC.text,
        password: passwordTEC.text,
      );

      setBusy(false);

      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext!,
          type: CoolAlertType.error,
          title: "Login Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        viewContext!.nextAndRemoveUntilPage(const HomePage());
      }
    }
  }

  void openRegister() async {
    viewContext!.nextPage(const RegisterPage());
  }

  void openForgotPassword() {
    viewContext!.nextPage(const ForgotPasswordPage());
  }
}
