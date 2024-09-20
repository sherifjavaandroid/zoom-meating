import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/services/validator.service.dart';

import 'package:meetup/view_models/forgot_password.view_model.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(context),
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
                    "Forgot Password".tr().text.xl2.semiBold.make(),

                    //form
                    Form(
                      key: model.formKey,
                      child: VStack(
                        [
                          //
                          CustomTextFormField(
                            labelText: "Phone Number".tr(),
                            hintText: "+233-----",
                            keyboardType: TextInputType.phone,
                            textEditingController: model.phoneTEC,
                            validator: FormValidator.validatePhone,
                          ).py12(),
                          //
                          CustomButton(
                            title: "Send OTP".tr(),
                            loading: model.isBusy,
                            onPressed: model.processForgotPassword,
                          ).h(Vx.dp48).centered().py12(),
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
