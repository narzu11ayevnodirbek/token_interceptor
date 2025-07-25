class RefreshResponse {
  factory RefreshResponse.failure() {
    return RefreshResponse(
      success: false,
      accessToken: '',
      refreshToken: '',
    );
  }

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      success: true,
      accessToken: json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }

  RefreshResponse({
    required this.success,
    required this.accessToken,
    required this.refreshToken,
  });
  final bool success;
  final String accessToken;
  final String refreshToken;
}
