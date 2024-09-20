import 'package:flutter/material.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:meetup/models/meeting.dart';
import 'package:meetup/models/user.dart';
import 'package:meetup/requests/meeting.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/services/meeting.service.dart';
import 'package:meetup/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class LoungeViewModel extends MyBaseViewModel {
  //
  final MeetingRequest _meetingRequest = MeetingRequest();
  User? currentUser;

  //
  int queryPage = 1;
  List<Meeting> publicMeetings = [];
  RefreshController refreshController = RefreshController();

  //
  LoungeViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    //
    getPublicMeetings();
  }

  /// Meeting creating and joining

  //initiate the vidoe call
  initiateNewMeeting({required Meeting meeting}) async {
    try {
      await MeetingService.startRoom(viewContext!, meeting);
    } catch (error) {
      viewContext!.showToast(
        msg: "There was an error joining new meeting".tr(),
      );
    }
  }

  ///
  void getPublicMeetings({bool initial = true}) async {
    //
    initial ? queryPage = 1 : queryPage++;
    //
    if (initial) {
      setBusyForObject(publicMeetings, true);
      refreshController.refreshCompleted();
    }
    //
    final mMeetings =
        await _meetingRequest.publicMeetingsRequest(page: queryPage);
    if (initial) {
      publicMeetings = mMeetings;
    } else {
      publicMeetings.addAll(mMeetings);
    }

    //
    initial
        ? setBusyForObject(publicMeetings, false)
        : refreshController.loadComplete();
  }
}
