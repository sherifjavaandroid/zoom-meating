import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/utils/ui_spacer.dart';
import 'package:meetup/view_models/history.vm.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/custom_list_view.dart';
import 'package:meetup/widgets/list_items/history.list_item.dart';
import 'package:meetup/widgets/states/empty.state.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<HistoryViewModel>.reactive(
      viewModelBuilder: () => HistoryViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          body: VStack(
            [
              //
              // "My Meetings".tr().text.xl2.semiBold.make(),
              // 20.heightBox,
              //
              AuthServices.authenticated()
                  ? CustomListView(
                      dataSet: model.meetings,
                      itemBuilder: (context, index) {
                        //
                        final meeting = model.meetings[index];
                        return HistoryListItem(
                          meeting,
                          () => model.initiateNewMeeting(meeting),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          UiSpacer.verticalSpace(space: 10),
                      isLoading: model.isBusy,
                      refreshController: model.refreshController,
                      canRefresh: true,
                      canPullUp: true,
                      onRefresh: model.getMeeting,
                      onLoading: () => model.getMeeting(initial: false),
                    ).expand()
                  : EmptyState(
                      auth: true,
                      actionPressed: model.openLogin,
                    ),
            ],
          ).p20().pOnly(bottom: Vx.dp64),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
