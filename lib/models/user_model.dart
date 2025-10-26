class UserModel {
  final String id;
  final String email;
  final String name;
  final String username;
  final String phone;
  final String? profileImage;
  final String role;
  final int? credit;
  final int fine;
  final String? refreshToken;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dateOfBirth;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.phone,
    this.profileImage,
    required this.role,
    this.credit,
    this.fine = 0,
    this.refreshToken,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['avatar']?['url'] ?? json['profile_image'],
      role: json['role'] ?? '',
      credit: json['credit'],
      fine: json['fine'] ?? 0,
      refreshToken: json['refreshToken'],
      isVerified: json['is_verified'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? json['updated_at'] ?? DateTime.now().toIso8601String()),
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'phone': phone,
      'avatar': profileImage != null ? {'url': profileImage} : null,
      'profile_image': profileImage,
      'role': role,
      'credit': credit,
      'fine': fine,
      'refreshToken': refreshToken,
      'is_verified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? phone,
    String? profileImage,
    String? role,
    int? credit,
    int? fine,
    String? refreshToken,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dateOfBirth,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      credit: credit ?? this.credit,
      fine: fine ?? this.fine,
      refreshToken: refreshToken ?? this.refreshToken,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
