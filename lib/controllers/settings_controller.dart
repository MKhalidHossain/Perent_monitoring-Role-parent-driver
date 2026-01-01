import 'package:flutter/foundation.dart';
import 'package:bbpool/models/settings_model.dart';

class SettingsController extends ChangeNotifier {


  SettingsModel _settings = SettingsModel(
    name: 'Antwon Taylor',
    email: 'antwontsy@gmail.com',
    profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
    phoneNumber: '+1 123 1234 1234',
    dateOfBirth: '01/01/2003',
    emergencyContactName: 'John Doe',
    emergencyContactRelationship: 'Guardian',
    emergencyContactNumber: '+1 123 1234 1234',
    emergencyContactName2: '',
    emergencyContactRelationship2: '',
    emergencyContactNumber2: '',
    handoffVerificationName: 'John Doe',
    handoffVerificationPin: '2503',
    darkMode: false,
    language: 'English',
    notificationsEnabled: true,
    emergencyContact: '',
    paymentMethod: '',
    rideCredits: 0,
    councilCode: '',
  );

  SettingsModel get settings => _settings;

  void updateSettings(SettingsModel newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void toggleDarkMode() {
    _settings = _settings.copyWith(darkMode: !_settings.darkMode);
    notifyListeners();
  }

  void toggleNotifications() {
    _settings = _settings.copyWith(notificationsEnabled: !_settings.notificationsEnabled);
    notifyListeners();
  }

  void updateLanguage(String language) {
    _settings = _settings.copyWith(language: language);
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? profileImage,
    String? phoneNumber,
    String? dateOfBirth,
  }) {
    _settings = _settings.copyWith(
      name: name,
      email: email,
      profileImage: profileImage,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
    );
    notifyListeners();
  }

  void updateEmergencyContacts({
    required String name,
    required String relationship,
    required String number,
    String? name2,
    String? relationship2,
    String? number2,
  }) {
    _settings = _settings.copyWith(
      emergencyContactName: name,
      emergencyContactRelationship: relationship,
      emergencyContactNumber: number,
      emergencyContactName2: name2 ?? '',
      emergencyContactRelationship2: relationship2 ?? '',
      emergencyContactNumber2: number2 ?? '',
      emergencyContact: name,
    );
    notifyListeners();
  }

  void updateChildHandoffVerification({
    required String name,
    required String pin,
  }) {
    _settings = _settings.copyWith(
      handoffVerificationName: name,
      handoffVerificationPin: pin,
    );
    notifyListeners();
  }

  List<SettingsSection> getSettingsSections({
    VoidCallback? onEmergencyContactTap,
    VoidCallback? onChildHandoffTap,
  }) {
    return [
      SettingsSection(
        title: 'App Preferences',
        items: [
          SettingsItem(
            title: 'Language',
            icon: 'language',
            hasArrow: true,
            onTap: () {
              // Handle language selection
            },
          ),
          SettingsItem(
            title: 'Dark Mode',
            icon: 'dark_mode',
            hasToggle: true,
            toggleValue: _settings.darkMode,
            hasArrow: false,
            onTap: toggleDarkMode,
          ),
          SettingsItem(
            title: 'Notification Settings',
            icon: 'notifications',
            hasArrow: true,
            onTap: () {
              // Handle notification settings
            },
          ),
        ],
      ),
      SettingsSection(
        title: 'Safety & Permissions',
        items: [
          SettingsItem(
            title: 'Emergency Contact Info',
            icon: 'emergency',
            hasArrow: true,
            onTap: onEmergencyContactTap,
          ),
          SettingsItem(
            title: 'Child Handoff Verification',
            icon: 'child_verification',
            hasArrow: true,
            onTap: onChildHandoffTap,
          ),
        ],
      ),
      SettingsSection(
        title: 'Payment & Billing',
        items: [
          SettingsItem(
            title: 'Payment Method',
            icon: 'payment',
            hasArrow: true,
            onTap: () {
              // Handle payment method
            },
          ),
          SettingsItem(
            title: 'Ride Credits',
            icon: 'credits',
            hasArrow: true,
            onTap: () {
              // Handle ride credits
            },
          ),
          SettingsItem(
            title: 'Council Code',
            icon: 'council',
            hasArrow: true,
            onTap: () {
              // Handle council code
            },
          ),
        ],
      ),
      SettingsSection(
        title: 'Help & Support',
        items: [
          SettingsItem(
            title: 'FAQ / How to use the app',
            icon: 'faq',
            hasArrow: true,
            onTap: () {
              // Handle FAQ
            },
          ),
          SettingsItem(
            title: 'Contact Support',
            icon: 'support',
            hasArrow: true,
            onTap: () {
              // Handle contact support
            },
          ),
          SettingsItem(
            title: 'Privacy Policy / Terms',
            icon: 'privacy',
            hasArrow: true,
            onTap: () {
              // Handle privacy policy
            },
          ),
        ],
      ),
      SettingsSection(
        title: 'Account Settings',
        items: [
          SettingsItem(
            title: 'Change Password',
            icon: 'password',
            hasArrow: true,
            onTap: () {
              // Handle change password
            },
          ),
        ],
      ),
    ];
  }

  void logout() {
    // Handle logout logic
    notifyListeners();
  }

  void deleteAccount() {
    // Handle delete account logic
    notifyListeners();
  }
}
