import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/models/meeting.dart';
import 'package:meetup/models/user.dart';
import 'package:meetup/requests/meeting.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/services/meeting.service.dart';
import 'package:meetup/view_models/base.view_model.dart';
import 'package:meetup/views/pages/auth/login.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryViewModel extends MyBaseViewModel {
  //
  final MeetingRequest _meetingRequest = MeetingRequest();
  //
  User? currentUser;
  //
  int queryPage = 1;
  List<Meeting> meetings = [];
  RefreshController refreshController = RefreshController();

  //
  HistoryViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);

      //
      getMeeting();
    }
    notifyListeners();
  }

  void getMeeting({bool initial = true}) async {
    //
    initial ? queryPage = 1 : queryPage++;
    //
    if (initial) {
      setBusy(true);
      refreshController.refreshCompleted();
    }
    //
    final mMeetings = await _meetingRequest.myMeetingsRequest(page: queryPage);
    if (initial) {
      meetings = mMeetings;
    } else {
      meetings.addAll(mMeetings);
    }

    //
    initial ? setBusy(false) : refreshController.loadComplete();
  }

  //initiate the vidoe call
  initiateNewMeeting(Meeting meeting) async {
    try {
      await MeetingService.startRoom(viewContext!, meeting);
    } catch (error) {
      viewContext!.showToast(
        msg: "There was an error joining new meeting".tr(),
      );
    }
  }

  openLogin() async {
    viewContext!.nextPage(const LoginPage());
  }
}
