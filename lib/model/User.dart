class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gmailAccount;
  final String phoneNumber;
  final String profilePic;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gmailAccount,
    required this.phoneNumber,
    required this.profilePic,
  });

  // Factory method để parse JSON thành User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', // Gán giá trị "" nếu null
      firstName: json['firstName'] ?? '', // Gán giá trị "" nếu null
      lastName: json['lastName'] ?? '', // Gán giá trị "" nếu null
      email: json['email'] ?? '', // Gán giá trị "" nếu null
      gmailAccount: json['gmailAccount'] ?? '', // Gán giá trị "" nếu null
      phoneNumber: json['phoneNumber'] ?? '', // Gán giá trị "" nếu null
      profilePic: json['profilePic'] ?? '', // Gán giá trị "" nếu null
    );
  }

  // Convert User object thành JSON (nếu cần gửi lại server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gmailAccount': gmailAccount,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
    };
  }
}
