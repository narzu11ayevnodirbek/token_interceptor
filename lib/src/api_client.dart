import 'package:dio/dio.dart';
import 'models/refresh_response.dart';

class ApiClient {
  ApiClient({required this.baseUrl});
  final String baseUrl;

  Future<RefreshResponse> refreshToken(String refreshToken) async {
    try {
      final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
      final Response<dynamic> res =
          await dio.post('/auth/refresh', data: <String, String>{
        'refresh_token': refreshToken,
      });
      return RefreshResponse.fromJson(res.data);
    } catch (_) {
      return RefreshResponse.failure();
    }
  }
}
