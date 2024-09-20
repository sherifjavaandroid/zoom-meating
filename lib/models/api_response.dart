import 'package:flutter/foundation.dart';

class ApiResponse {
  int get totalDataCount => body["meta"]["total"];
  int get totalPageCount => body["pagination"]["total_pages"];
  List get data => body["data"] ?? [];
  // Just a way of saying there was no error with the request and response return
  bool get allGood => errors == null || errors!.isEmpty;
  bool hasError() => errors != null && errors!.isNotEmpty;
  bool hasData() => data.isNotEmpty;
  int? code;
  String? message;
  dynamic body;
  List? errors;

  ApiResponse({
    this.code,
    this.message,
    this.body,
    this.errors,
  });

  factory ApiResponse.fromResponse(dynamic response) {
    //
    int code = response.statusCode;
    dynamic body = response.data; // Would mostly be a Map
    List errors = [];
    String message = "";

    switch (code) {
      case 200:
        try {
          message = body["message"];
        } catch (error) {
          if (kDebugMode) {
            print("Message reading error ==> $error");
          }
        }

        break;
      default:
        message = body["message"] ??
            "Whoops! Something went wrong, please contact support.";
        errors.add(message);
        break;
    }

    return ApiResponse(
      code: code,
      message: message,
      body: body,
      errors: errors,
    );
  }
}
