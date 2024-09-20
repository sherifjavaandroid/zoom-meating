import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/view_models/meeting.vm.dart';
import 'package:meetup/views/pages/meeting/widgets/meeting_action_group.dart';
import 'package:meetup/views/pages/meeting/widgets/meeting_action_view.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({Key? key}) : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    with AutomaticKeepAliveClientMixin<MeetingPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      body: ViewModelBuilder<MeetingViewModel>.reactive(
        viewModelBuilder: () => MeetingViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return VStack(
            [
              //title
              // "Meeting".tr().text.xl2.semiBold.make(),
              // 20.heightBox,

              //action button group
              MeetingActionGroup(model),
              //Meeting action view
              MeetingActionView(model).py16(),
            ],
          ).p20().pOnly(bottom: Vx.dp64).scrollVertical();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
