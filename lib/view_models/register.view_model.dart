import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/extensions/buildcontext.dart';
import 'package:meetup/requests/auth.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/views/pages/home.page.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterViewModel extends MyBaseViewModel {
  //
  final AuthRequest _authRequest = AuthRequest();

  //the textediting controllers
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  RegisterViewModel(BuildContext context) {
    viewContext = context;
  }

  void processRegister() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      //
      //

      setBusy(true);

      final apiResponse = await _authRequest.registerRequest(
        name: nameTEC.text,
        email: emailTEC.text,
        phone: phoneTEC.text,
        password: passwordTEC.text,
      );

      setBusy(false);

      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext!,
          type: CoolAlertType.error,
          title: "Registration Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        //
        viewContext!.nextPage(const HomePage());
      }
    }
  }

  void openLogin() async {
    viewContext!.pop();
  }
}
