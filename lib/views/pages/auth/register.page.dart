import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/services/validator.service.dart';
import 'package:meetup/view_models/register.view_model.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
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
                  AppImages.onboarding2,
                ).hOneForth(context).centered(),
                //
                VStack(
                  [
                    //
                    "Join Us".tr().text.xl2.semiBold.make(),
                    "Create an account now".tr().text.light.make(),

                    //form
                    Form(
                      key: model.formKey,
                      child: VStack(
                        [
                          //
                          CustomTextFormField(
                            labelText: "Name".tr(),
                            textEditingController: model.nameTEC,
                            validator: FormValidator.validateName,
                          ).py12(),
                          //
                          CustomTextFormField(
                            labelText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            textEditingController: model.emailTEC,
                            validator: FormValidator.validateEmail,
                          ).py12(),
                          //
                          CustomTextFormField(
                            labelText: "Phone".tr(),
                            hintText: "+233-----",
                            keyboardType: TextInputType.phone,
                            textEditingController: model.phoneTEC,
                            validator: FormValidator.validatePhone,
                          ).py12(),
                          //
                          CustomTextFormField(
                            labelText: "Password".tr(),
                            obscureText: true,
                            textEditingController: model.passwordTEC,
                            validator: FormValidator.validatePassword,
                          ).py12(),

                          //
                          CustomButton(
                            title: "Create Account".tr(),
                            loading: model.isBusy,
                            onPressed: model.processRegister,
                          ).centered().py12(),

                          //register
                          "OR".tr().text.light.makeCentered(),
                          "Already have an Account"
                              .tr()
                              .text
                              .semiBold
                              .makeCentered()
                              .py12()
                              .onInkTap(model.openLogin),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),
                    ).py20(),
                  ],
                ).wFull(context).p20()

                //
              ],
            ).scrollVertical(),
          ),
        );
      },
    );
  }
}
