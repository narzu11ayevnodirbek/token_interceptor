import 'package:dio/dio.dart';
import 'models/refresh_response.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<RefreshResponse> refreshToken(String refreshToken) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      final res = await dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      return RefreshResponse.fromJson(res.data);
    } catch (_) {
      return RefreshResponse.failure();
    }
  }
}
