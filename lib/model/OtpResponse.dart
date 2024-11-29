class OtpResponse {
  final String token;
  OtpResponse({required this.token});
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      token: json['token'],
    );
  }
}
