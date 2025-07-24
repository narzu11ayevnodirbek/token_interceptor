import 'package:dio/dio.dart';
import 'package:token_interceptor/token_interceptor.dart';
import 'dart:developer';

void main() async {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://your-api.com'));

  final ApiClient apiClient = ApiClient(baseUrl: 'https://your-api.com');

  dio.interceptors.add(AuthInterceptor(dio: dio, apiClient: apiClient));

  // to save token after login
  await TokenManager.instance.setTokens(
    'your-access-token',
    refreshToken: 'your-refresh-token',
    saveRefreshToken: true,
  );

  // any API request
  try {
    final Response<dynamic> res = await dio.get('/user/profile');
    log('Profile: ${res.data}');
  } catch (e) {
    log('Error: $e');
  }
}
