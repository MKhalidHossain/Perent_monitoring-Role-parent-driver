class ChildInfoModel {
  final String id;
  final String fullName;
  final String schoolName;
  final String emergencyContactName;
  final List<String> emergencyContactNumber;
  final String relationship;
  final DateTime? dateOfBirth;
  final Avatar? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChildInfoModel({
    required this.id,
    required this.fullName,
    required this.schoolName,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
    required this.relationship,
    this.dateOfBirth,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildInfoModel.fromJson(Map<String, dynamic> json) {
    return ChildInfoModel(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      schoolName: json['schoolName'] ?? '',
      emergencyContactName: json['emergencyContactName'] ?? '',
      emergencyContactNumber: json['emergencyContactNumber'] != null
          ? List<String>.from(json['emergencyContactNumber'])
          : [],
      relationship: json['relationship'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      avatar: json['avatar'] != null
          ? Avatar.fromJson(json['avatar'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'fullName': fullName,
      'schoolName': schoolName,
      'emergencyContactName': emergencyContactName,
      'emergencyContactNumber': emergencyContactNumber,
      'relationship': relationship,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'avatar': avatar?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Avatar {
  final String? publicId;
  final String? url;

  Avatar({
    this.publicId,
    this.url,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }
}

