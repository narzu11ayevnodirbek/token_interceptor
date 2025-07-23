import 'package:dio/dio.dart';
import 'token_manager.dart';
import 'api_client.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final ApiClient apiClient;

  AuthInterceptor({
    required this.dio,
    required this.apiClient,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = TokenManager.instance.accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = await TokenManager.instance.getRefreshToken();
    if (refreshToken == null) {
      await TokenManager.instance.clearTokens();
      return handler.next(err);
    }

    final refreshResponse = await apiClient.refreshToken(refreshToken);
    if (!refreshResponse.success) {
      await TokenManager.instance.clearTokens();
      return handler.next(err);
    }

    await TokenManager.instance.setTokens(
      refreshResponse.accessToken,
      refreshToken: refreshResponse.refreshToken,
      saveRefreshToken: true,
    );

    final newRequest = err.requestOptions..headers['Authorization'] = 'Bearer ${refreshResponse.accessToken}';
    final response = await dio.fetch(newRequest);
    return handler.resolve(response);
  }
}
