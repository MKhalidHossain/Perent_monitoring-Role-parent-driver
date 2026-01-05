class SettingsModel {
  final String name;
  final String email;
  final String profileImage;
  final String phoneNumber;
  final String dateOfBirth;
  final String emergencyContactName;
  final String emergencyContactRelationship;
  final String emergencyContactNumber;
  final String emergencyContactName2;
  final String emergencyContactRelationship2;
  final String emergencyContactNumber2;
  final String handoffVerificationName;
  final String handoffVerificationPin;
  final bool darkMode;
  final String language;
  final bool notificationsEnabled;
  final String emergencyContact;
  final String paymentMethod;
  final int rideCredits;
  final String councilCode;

  SettingsModel({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.emergencyContactName,
    required this.emergencyContactRelationship,
    required this.emergencyContactNumber,
    required this.emergencyContactName2,
    required this.emergencyContactRelationship2,
    required this.emergencyContactNumber2,
    required this.handoffVerificationName,
    required this.handoffVerificationPin,
    required this.darkMode,
    required this.language,
    required this.notificationsEnabled,
    required this.emergencyContact,
    required this.paymentMethod,
    required this.rideCredits,
    required this.councilCode,
  });

  SettingsModel copyWith({
    String? name,
    String? email,
    String? profileImage,
    String? phoneNumber,
    String? dateOfBirth,
    String? emergencyContactName,
    String? emergencyContactRelationship,
    String? emergencyContactNumber,
    String? emergencyContactName2,
    String? emergencyContactRelationship2,
    String? emergencyContactNumber2,
    String? handoffVerificationName,
    String? handoffVerificationPin,
    bool? darkMode,
    String? language,
    bool? notificationsEnabled,
    String? emergencyContact,
    String? paymentMethod,
    int? rideCredits,
    String? councilCode,
  }) {
    return SettingsModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactRelationship:
          emergencyContactRelationship ?? this.emergencyContactRelationship,
      emergencyContactNumber:
          emergencyContactNumber ?? this.emergencyContactNumber,
      emergencyContactName2: emergencyContactName2 ?? this.emergencyContactName2,
      emergencyContactRelationship2:
          emergencyContactRelationship2 ?? this.emergencyContactRelationship2,
      emergencyContactNumber2:
          emergencyContactNumber2 ?? this.emergencyContactNumber2,
      handoffVerificationName:
          handoffVerificationName ?? this.handoffVerificationName,
      handoffVerificationPin:
          handoffVerificationPin ?? this.handoffVerificationPin,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rideCredits: rideCredits ?? this.rideCredits,
      councilCode: councilCode ?? this.councilCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'emergencyContactName': emergencyContactName,
      'emergencyContactRelationship': emergencyContactRelationship,
      'emergencyContactNumber': emergencyContactNumber,
      'emergencyContactName2': emergencyContactName2,
      'emergencyContactRelationship2': emergencyContactRelationship2,
      'emergencyContactNumber2': emergencyContactNumber2,
      'handoffVerificationName': handoffVerificationName,
      'handoffVerificationPin': handoffVerificationPin,
      'darkMode': darkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'emergencyContact': emergencyContact,
      'paymentMethod': paymentMethod,
      'rideCredits': rideCredits,
      'councilCode': councilCode,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      emergencyContactName: json['emergencyContactName'] ?? '',
      emergencyContactRelationship: json['emergencyContactRelationship'] ?? '',
      emergencyContactNumber: json['emergencyContactNumber'] ?? '',
      emergencyContactName2: json['emergencyContactName2'] ?? '',
      emergencyContactRelationship2:
          json['emergencyContactRelationship2'] ?? '',
      emergencyContactNumber2: json['emergencyContactNumber2'] ?? '',
      handoffVerificationName: json['handoffVerificationName'] ?? '',
      handoffVerificationPin: json['handoffVerificationPin'] ?? '',
      darkMode: json['darkMode'] ?? false,
      language: json['language'] ?? 'English',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emergencyContact: json['emergencyContact'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      rideCredits: json['rideCredits'] ?? 0,
      councilCode: json['councilCode'] ?? '',
    );
  }
}

class SettingsItem {
  final String title;
  final String? subtitle;
  final String icon;
  final bool hasToggle;
  final bool toggleValue;
  final bool hasArrow;
  final void Function()? onTap;

  SettingsItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.hasToggle = false,
    this.toggleValue = false,
    this.hasArrow = true,
    this.onTap,
  });
}

class SettingsSection {
  final String title;
  final List<SettingsItem> items;

  SettingsSection({
    required this.title,
    required this.items,
  });
}
