import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_colors.dart';
import 'package:meetup/services/validator.service.dart';
import 'package:meetup/view_models/meeting.vm.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

import 'new_meeting.view.dart';

class MeetingActionView extends StatelessWidget {
  const MeetingActionView(this.model, {Key? key}) : super(key: key);

  final MeetingViewModel model;

  @override
  Widget build(BuildContext context) {
    return model.selectedAction == 0
        ? Form(
            key: model.formKey,
            child: VStack(
              [
                //title
                "Join an existing meeting"
                    .tr()
                    .text
                    .lg
                    .semiBold
                    .color(AppColor.primaryColor)
                    .make()
                    .pOnly(bottom: Vx.dp12),
                //
                CustomTextFormField(
                  labelText: "Meeting ID".tr(),
                  validator: (value) => FormValidator.validateEmpty(
                    value,
                    errorTitle: "Meeting ID".tr(),
                  ),
                  textEditingController: model.meetingIdTEC,
                  suffixIcon: const Icon(
                    LineIcons.clipboard,
                  ).onInkTap(
                    model.pasteMeetingId,
                  ),
                ).pOnly(bottom: Vx.dp12),
                CustomTextFormField(
                  labelText: "Nick Name".tr(),
                  validator: (value) => FormValidator.validateEmpty(
                    value,
                    errorTitle: "Nick Name".tr(),
                  ),
                  textEditingController: model.meetingNickNameTEC,
                ).pOnly(bottom: Vx.dp12),
                //
                CustomButton(
                  title: "Join".tr(),
                  onPressed: model.startJoinMeeting,
                  loading: model.isBusy,
                ).centered(),
              ],
            ),
          )
        : NewMeetingView(model);
  }
}
