class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String gmailAccount;
  final String phoneNumber;
  final String profilePic;
  final DateTime dateOfBirth;
  final bool twoFactorEnabled;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.gmailAccount,
    required this.phoneNumber,
    required this.profilePic,
    required this.dateOfBirth,
    required this.twoFactorEnabled,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory method để parse JSON thành User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', // Gán giá trị "" nếu null
      firstName: json['firstName'] ?? '', // Gán giá trị "" nếu null
      lastName: json['lastName'] ?? '', // Gán giá trị "" nếu null
      email: json['email'] ?? '', // Gán giá trị "" nếu null
      gender: json['gender'] ?? '',
      gmailAccount: json['gmailAccount'] ?? '', // Gán giá trị "" nếu null
      phoneNumber: json['phoneNumber'] ?? '', // Gán giá trị "" nếu null
      profilePic: json['profilePic'] ?? '', // Gán giá trị "" nếu null
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert User object thành JSON (nếu cần gửi lại server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'gmailAccount': gmailAccount,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'twoFactorEnabled': twoFactorEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
