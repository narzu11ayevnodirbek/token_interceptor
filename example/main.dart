import 'package:dio/dio.dart';
import 'package:token_interceptor/token_interceptor.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://your-api.com'));

  final apiClient = ApiClient(baseUrl: 'https://your-api.com');

  dio.interceptors.add(AuthInterceptor(dio: dio, apiClient: apiClient));

  // to save token after login
  await TokenManager.instance.setTokens(
    'your-access-token',
    refreshToken: 'your-refresh-token',
    saveRefreshToken: true,
  );

  // any API request
  try {
    final res = await dio.get('/user/profile');
    print('Profile: ${res.data}');
  } catch (e) {
    print('Error: $e');
  }
}
