import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_colors.dart';
import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/utils/ui_spacer.dart';
import 'package:meetup/view_models/meeting.vm.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/buttons/image_picker.view.dart';
import 'package:meetup/widgets/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class NewMeetingView extends StatelessWidget {
  const NewMeetingView(this.model, {Key? key}) : super(key: key);

  final MeetingViewModel model;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //title
        "Host a new meeting"
            .tr()
            .text
            .lg
            .semiBold
            .color(AppColor.primaryColor)
            .make()
            .pOnly(bottom: Vx.dp12),
        //
        CustomTextFormField(
          labelText: "Meeting ID *".tr(),
          textEditingController: model.newMeetingIdTEC,
          prefixIcon: (AppStrings.meetingPrefixID.isNotBlank)
              ? SizedBox(
                  child: AppStrings.meetingPrefixID.text.center
                      .make()
                      .centered()
                      .p(5),
                  width: 60,
                )
              : null,
          suffixIcon: const Icon(
            LineIcons.copy,
          ).onInkTap(
            model.copyMeetingId,
          ),
        ),
        "New Meeting ID"
            .tr()
            .text
            .sm
            .underline
            .make()
            .onInkTap(model.newMeetingCode)
            .pOnly(top: Vx.dp5, bottom: Vx.dp12),
        CustomTextFormField(
          labelText: "Meeting title (optional)".tr(),
          textEditingController: model.newMeetingTitleTEC,
        ).pOnly(bottom: Vx.dp6),

        //Public (ONLY FOR AUTH USERS)
        model.currentUser != null
            ? HStack(
                [
                  Checkbox(
                    value: model.isNewMeetingPublic,
                    onChanged: model.toggleMeetingPublic,
                  ),
                  "Public Meeting".tr().text.make().expand(),
                ],
              ).onTap(() {
                model.toggleMeetingPublic(!model.isNewMeetingPublic);
              }).pOnly(bottom: Vx.dp12)
            : UiSpacer.emptySpace(),
        //
        ImagePickerView(
          model.meetingBanner,
          model.pickMeetingImage,
          model.removeBanner,
        ),

        //
        CustomButton(
          title: "Share Meeting".tr(),
          onPressed: model.shareNewMeeting,
        ),
        //
        CustomButton(
          title: "Create & Enter Now".tr(),
          onPressed: model.startNewMeeting,
          loading: model.isBusy,
        ).wFull(context).pOnly(bottom: Vx.dp12),
      ],
    );
  }
}
