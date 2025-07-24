import 'package:dio/dio.dart';
import 'package:token_interceptor/src/models/refresh_response.dart';
import 'token_manager.dart';
import 'api_client.dart';

/// An interceptor that attaches Authorization header to all requests
/// and refreshes token on 401 errors.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.dio,
    required this.apiClient,
  });
  final Dio dio;
  final ApiClient apiClient;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String? accessToken = TokenManager.instance.accessToken;
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

    final String? refreshToken = await TokenManager.instance.getRefreshToken();
    if (refreshToken == null) {
      await TokenManager.instance.clearTokens();
      return handler.next(err);
    }

    final RefreshResponse refreshResponse =
        await apiClient.refreshToken(refreshToken);
    if (!refreshResponse.success) {
      await TokenManager.instance.clearTokens();
      return handler.next(err);
    }

    await TokenManager.instance.setTokens(
      refreshResponse.accessToken,
      refreshToken: refreshResponse.refreshToken,
      saveRefreshToken: true,
    );

    final RequestOptions newRequest = err.requestOptions
      ..headers['Authorization'] = 'Bearer ${refreshResponse.accessToken}';
    final Response<dynamic> response = await dio.fetch(newRequest);
    return handler.resolve(response);
  }
}
