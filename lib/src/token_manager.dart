import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  TokenManager._internal();
  static final TokenManager instance = TokenManager._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accessToken;

  String? get accessToken => _accessToken;

  /// Sets access and refresh tokens securely.
  ///
  /// [accessToken] - JWT/Bearer access token
  /// [refreshToken] - optional refresh token
  Future<void> setTokens(
    String accessToken, {
    String? refreshToken,
    bool saveRefreshToken = false,
  }) async {
    _accessToken = accessToken;
    if (saveRefreshToken && refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    await _storage.delete(key: 'refresh_token');
  }
}
