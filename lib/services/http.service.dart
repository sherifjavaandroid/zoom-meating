import 'dart:io';
import 'package:dio/dio.dart';
import 'package:meetup/constants/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.service.dart';

class HttpService {
  String host = Api.baseUrl;
  BaseOptions? baseOptions;
  Dio? dio;
  SharedPreferences? prefs;

  Future<Map<String, String>> getHeaders() async {
    final userToken = await AuthServices.getAuthBearerToken();
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $userToken",
    };
  }

  HttpService() {
    AuthServices.getPrefs();

    baseOptions = BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status! <= 500;
      },
      // connectTimeout: 300,
    );
    dio = Dio(baseOptions);
  }

  //for get api calls
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio!.get(
      uri,
      options: mOptions,
      queryParameters: queryParameters,
    );
  }

  //for post api calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio!.post(
      uri,
      data: body,
      options: mOptions,
    );
  }

  //for post api calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    var response = Response(requestOptions: RequestOptions(path: uri));

    try {
      response = await dio!.post(
        uri,
        data: FormData.fromMap(body),
        options: mOptions,
      );
    } on DioException catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, String> body) async {
    String uri = "$host$url";
    return dio!.patch(
      uri,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    String uri = "$host$url";
    return dio!.delete(
      uri,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  Response formatDioExecption(DioException ex) {
    var response = Response(requestOptions: ex.requestOptions);
    response.statusCode = 400;
    try {
      if (ex.type == DioExceptionType.connectionTimeout) {
        response.data = {
          "message":
              "Connection timeout. Please check your internet connection and try again",
        };
      } else {
        response.data = {
          "message": ex.message,
        };
      }
    } catch (error) {
      var response = Response(requestOptions: ex.requestOptions);
      response.statusCode = 400;
      response.data = {
        "message": "Please check your internet connection and try again",
      };
    }

    return response;
  }
}
