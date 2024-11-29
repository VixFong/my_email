
class LoginResponse{
  final String? token;
  final bool authenticated;
  final String? otpToken;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profilePic;

  LoginResponse({
    this.token,
    required this.authenticated,
    this.otpToken,
    this.firstName,
    this.lastName,
    this.email,
    this.profilePic,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '', // Gán giá trị "" nếu null
      authenticated: json['authenticated'] ?? '', // Gán giá trị "" nếu null
      otpToken:  json['otpToken'] ?? '', // Gán giá trị "" nếu null
      firstName: json['firstName'] ?? '', // Gán giá trị "" nếu null
      lastName: json['lastName'] ?? '', // Gán giá trị "" nếu null
      email: json['email'] ?? '', // Gán giá trị "" nếu null
      profilePic: json['profilePic'] ?? '', // Gán giá trị "" nếu null
    );
  }
}