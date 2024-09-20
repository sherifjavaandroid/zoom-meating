import 'package:meetup/constants/api.dart';
import 'package:meetup/models/api_response.dart';
import 'package:meetup/services/http.service.dart';

class SettingsRequest extends HttpService {
  //
  Future<ApiResponse> appSettings() async {
    final apiResult = await get(Api.settings);
    return ApiResponse.fromResponse(apiResult);
  }
}
