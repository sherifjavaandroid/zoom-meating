import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meetup/constants/api.dart';
import 'package:meetup/models/api_response.dart';
import 'package:meetup/models/meeting.dart';
import 'package:meetup/services/http.service.dart';

class MeetingRequest extends HttpService {
  //
  Future<List<Meeting>> myMeetingsRequest({int page = 1}) async {
    final apiResult = await get(
      Api.meetings,
      queryParameters: {
        "page": page,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((meetingObject) => Meeting.fromJSON(
                meetingObject,
              ))
          .toList();
    } else {
      throw apiResponse.message ?? "An error occured";
    }
  }

  //
  Future<List<Meeting>> publicMeetingsRequest({int page = 1}) async {
    final apiResult = await get(
      Api.publicMeetings,
      queryParameters: {"page": page},
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((meetingObject) => Meeting.fromJSON(
                meetingObject,
              ))
          .toList();
    } else {
      throw apiResponse.message ?? "An error occured";
    }
  }

  //
  Future<ApiResponse> newMeetingRequest({
    String? meetingID,
    String? meetingTitle,
    File? meetingBanner,
    bool isPublic = false,
  }) async {
    // print("Banner ==> ${meetingBanner == null ? 'No' : 'Yes'}");
    final apiResult = await postWithFiles(
      Api.meetings,
      {
        "title": meetingTitle ?? "Untitled",
        "id": meetingID,
        "public": isPublic ? 1 : 0,
        "banner": meetingBanner != null
            ? await MultipartFile.fromFile(
                meetingBanner.path,
              )
            : null,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> joinMeetingRequest({
    String? meetingID,
  }) async {
    // print("Join Meeting ID ==> $meetingID");
    final apiResult = await get("${Api.joinMeeting}/$meetingID");
    // print("Join Meeting ==> $apiResult");
    return ApiResponse.fromResponse(apiResult);
  }
}
