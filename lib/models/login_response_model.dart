class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String id;
  final String email;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.id,
    required this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      role: json['role'] ?? '',
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'role': role,
      '_id': id,
      'email': email,
    };
  }

  LoginResponseModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? role,
    String? id,
    String? email,
  }) {
    return LoginResponseModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }
}
