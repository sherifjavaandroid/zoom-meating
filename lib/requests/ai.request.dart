import 'package:meetup/constants/api.dart';
import 'package:meetup/models/api_response.dart';
import 'package:meetup/models/messages.dart';
import 'package:meetup/services/http.service.dart';

class AIRequest extends HttpService {
  Future<ApiResponse> chatCompletion({
    required List<Messages> messages,
    required String newMessage,
  }) async {
    final apiResult = await post(
      Api.aiChat,
      {
        "messages": messages.map((e) => e.toJson()).toList(),
        "message": newMessage,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    return apiResponse;
  }

  //image generator
  Future<ApiResponse> generateImage({
    required String prompt,
    int? numberOfImages = 2,
    ImageSize? size = ImageSize.size256,
    String? responseFormat = "url",
  }) async {
    final apiResult = await post(
      Api.aiImageGen,
      {
        "prompt": prompt,
        "number_of_images": numberOfImages,
        "size": size?.name,
        "response_format": responseFormat,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }
}
