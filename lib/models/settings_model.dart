class SettingsModel {
  final String name;
  final String email;
  final String profileImage;
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
