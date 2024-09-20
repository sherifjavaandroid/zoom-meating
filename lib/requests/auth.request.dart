import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meetup/constants/api.dart';
import 'package:meetup/models/api_response.dart';
import 'package:meetup/services/http.service.dart';

class AuthRequest extends HttpService {
  //
  Future<ApiResponse> loginRequest({
    required String email,
    required String password,
  }) async {
    final apiResult = await post(
      Api.login,
      {
        "email": email,
        "password": password,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> registerRequest({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final apiResult = await post(
      Api.register,
      {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> resetPasswordRequest({
    required String phone,
    required String password,
    required String firebaseToken,
  }) async {
    final apiResult = await post(
      Api.forgotPassword,
      {
        "phone": phone,
        "password": password,
        "firebase_id_token": firebaseToken,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> logoutRequest() async {
    final apiResult = await get(Api.logout);
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> updateProfile({
    File? photo,
    String? name,
    String? email,
    String? phone,
  }) async {
    final apiResult = await postWithFiles(
      Api.updateProfile,
      {
        "_method": "PUT",
        "name": name,
        "email": email,
        "phone": phone,
        "photo": photo != null
            ? await MultipartFile.fromFile(
                photo.path,
              )
            : null,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> deleteProfileRequest() async {
    final apiResult = await delete(Api.deleteProfile);
    return ApiResponse.fromResponse(apiResult);
  }
}
