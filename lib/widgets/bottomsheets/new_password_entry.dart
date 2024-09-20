import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/services/validator.service.dart';
import 'package:meetup/view_models/forgot_password.view_model.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class NewPasswordEntry extends StatelessWidget {
  const NewPasswordEntry({required this.onSubmit, required this.vm, Key? key})
      : super(key: key);

  final Function(String) onSubmit;
  final ForgotPasswordViewModel vm;

  @override
  Widget build(BuildContext context) {
    //
    final resetFormKey = GlobalKey<FormState>();

    return Form(
      key: resetFormKey,
      child: VStack(
        [
          //
          "New Password".tr().text.bold.xl2.makeCentered(),
          "Please enter account new password".tr().text.makeCentered(),
          //pin code
          CustomTextFormField(
            labelText: "New Password".tr(),
            textEditingController: vm.passwordTEC,
            validator: FormValidator.validatePassword,
            obscureText: true,
          ).py12(),

          //submit
          CustomButton(
            title: "Reset Password".tr(),
            loading: vm.isBusy,
            onPressed: () {
              if (resetFormKey.currentState!.validate()) {
                onSubmit(vm.passwordTEC.text);
              }
            },
          ).h(Vx.dp48),
        ],
      ).p20().h(context.percentHeight * 90),
    );
  }
}
