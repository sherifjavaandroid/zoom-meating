import 'package:flutter/material.dart';
import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/models/meeting.dart';
import 'package:meetup/models/user.dart';
import 'package:meetup/services/ai.service.dart';
import 'package:meetup/services/auth.service.dart';

import 'package:omni_jitsi_meet/jitsi_meet.dart';

class MeetingService {
  //
  static Future<dynamic> startRoom(
    BuildContext context,
    Meeting meeting, {
    String? displayName,
  }) async {
    //
    User? currentUser;

    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser();
    }

    //
    String? meetingServerUrl =
        ApiService().getAppSettings()['jitsi_meeting_domain'];
    //
    if (meetingServerUrl != null && !meetingServerUrl.startsWith("http")) {
      meetingServerUrl = "https://$meetingServerUrl";
    }

    bool iAMModerator = currentUser != null && meeting.mine;
    var options = JitsiMeetingOptions(
      serverURL: meetingServerUrl,
      room: meeting.meetingID!,
      subject: meeting.meetingTitle,
      userDisplayName: displayName ??
          (currentUser != null
              ? currentUser.name
              : ("Anonymous-User-" +
                  DateTime.now().millisecondsSinceEpoch.toString())),
      userEmail: currentUser != null ? currentUser.email : "",
      userAvatarURL: currentUser != null ? currentUser.photo : "",
      featureFlags: {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
        FeatureFlagEnum.CALENDAR_ENABLED: false,
        FeatureFlagEnum.PREJOIN_PAGE_HIDE_DISPLAY_NAME: true,
        FeatureFlagEnum.KICK_OUT_ENABLED: iAMModerator,
        FeatureFlagEnum.PREJOIN_PAGE_ENABLED: true,
      },
      configOverrides: {
        //
        "disableModeratorIndicator": iAMModerator,
        "startAudioOnly": true,
        //local audio mute
        "startWithAudioMuted": true,
        "defaultRemoteDisplayName": "Other Participant",
        //
        "prejoinConfig": {
          //
          "enabled": true,
          "hideExtraJoinButtons": ['no-audio', 'by-phone'],
          "hideDisplayName": false,
        },
        //
        "enableInsecureRoomNameWarning": true,
        "inviteAppName": AppStrings.appName,
        "deeplinking.disabled": false,
        "disableInviteFunctions": !iAMModerator,

        // Options related to the participants pane.
        "participantsPane": {
          // Hides the moderator settings tab.
          "hideModeratorSettingsTab": !iAMModerator,
          // Hides the more actions button.
          "hideMoreActionsButton": !iAMModerator,
          // Hides the mute all button.
          "hideMuteAllButton": !iAMModerator,
        },

        //CONFIG URL: https://github.com/jitsi/jitsi-meet/blob/master/config.js
      },
    );
    await JitsiMeet.joinMeeting(options);

    //
  }
}
