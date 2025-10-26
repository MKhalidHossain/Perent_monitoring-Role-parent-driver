class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String username;
  final String? credit;
  final String role;
  final int fine;
  final String? location;
  final String? avatarUrl;
  final String? avatarPublicId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.credit,
    required this.role,
    required this.fine,
    this.location,
    this.avatarUrl,
    this.avatarPublicId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      credit: json['credit'],
      role: json['role'] ?? '',
      fine: json['fine'] ?? 0,
      location: json['location'],
      avatarUrl: json['avatar']?['url'],
      avatarPublicId: json['avatar']?['public_id'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'username': username,
      'credit': credit,
      'role': role,
      'fine': fine,
      'location': location,
      'avatar': {
        'url': avatarUrl,
        'public_id': avatarPublicId,
      },
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    String? credit,
    String? role,
    int? fine,
    String? location,
    String? avatarUrl,
    String? avatarPublicId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      credit: credit ?? this.credit,
      role: role ?? this.role,
      fine: fine ?? this.fine,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarPublicId: avatarPublicId ?? this.avatarPublicId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}