import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static final TokenManager instance = TokenManager._internal();
  final _storage = const FlutterSecureStorage();

  String? _accessToken;

  TokenManager._internal();

  String? get accessToken => _accessToken;

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
