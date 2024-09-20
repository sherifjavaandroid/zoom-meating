import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_colors.dart';
import 'package:meetup/view_models/meeting.vm.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

class MeetingActionGroup extends StatelessWidget {
  const MeetingActionGroup(this.model, {Key? key}) : super(key: key);

  final MeetingViewModel model;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //join
        CustomButton(
          title: "Join Meeting".tr(),
          shapeRadius: Vx.dp0,
          color: model.selectedAction == 0
              ? null
              : AppColor.accentColor.withOpacity(0.50),
          onPressed: () => model.changeMeetingView(0),
        ).expand(),
        //create/host
        CustomButton(
          title: "Host Meeting".tr(),
          shapeRadius: Vx.dp0,
          color: model.selectedAction == 1
              ? null
              : AppColor.accentColor.withOpacity(0.50),
          onPressed: () => model.changeMeetingView(1),
        ).expand(),
      ],
    );
  }
}
