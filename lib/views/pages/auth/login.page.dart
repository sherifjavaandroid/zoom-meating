import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/services/validator.service.dart';
import 'package:meetup/view_models/login.view_model.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/custom_text_form_field.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          body: SafeArea(
            top: true,
            bottom: false,
            child: VStack(
              [
                Image.asset(
                  AppImages.onboarding1,
                ).hOneForth(context).centered(),
                //
                VStack(
                  [
                    //
                    "Welcome Back".tr().text.xl2.semiBold.make(),
                    "Login to continue".tr().text.light.make(),

                    //form
                    Form(
                      key: model.formKey,
                      child: VStack(
                        [
                          //
                          CustomTextFormField(
                            labelText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            textEditingController: model.emailTEC,
                            validator: FormValidator.validateEmail,
                          ).py12(),
                          CustomTextFormField(
                            labelText: "Password".tr(),
                            obscureText: true,
                            textEditingController: model.passwordTEC,
                            validator: FormValidator.validatePassword,
                          ).py12(),

                          //
                          "Forgot Password ?"
                              .tr()
                              .text
                              .underline
                              .make()
                              .onInkTap(
                                model.openForgotPassword,
                              ),
                          //
                          CustomButton(
                            title: "Login".tr(),
                            loading: model.isBusy,
                            onPressed: model.processLogin,
                          ).centered().py12(),

                          //register
                          "OR".tr().text.light.makeCentered(),
                          "Create An Account"
                              .tr()
                              .text
                              .semiBold
                              .makeCentered()
                              .py12()
                              .onInkTap(model.openRegister),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),
                    ).py20(),
                  ],
                )
                    .wFull(context)
                    .p20()
                    .scrollVertical()
                    .box
                    .color(
                      Theme.of(context).highlightColor,
                    )
                    .make()
                    .expand(),

                //
              ],
            ),
          ),
        );
      },
    );
  }
}
