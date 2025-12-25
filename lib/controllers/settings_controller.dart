import 'package:flutter/foundation.dart';
import 'package:bbpool/models/settings_model.dart';

class SettingsController extends ChangeNotifier {


  SettingsModel _settings = SettingsModel(
    name: 'Antwon Taylor',
    email: 'antwontsy@gmail.com',
    profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
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

  void updateProfile({String? name, String? email, String? profileImage}) {
    _settings = _settings.copyWith(
      name: name,
      email: email,
      profileImage: profileImage,
    );
    notifyListeners();
  }

  List<SettingsSection> getSettingsSections() {
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
            onTap: () {
              // Handle emergency contact
            },
          ),
          SettingsItem(
            title: 'Child Handoff Verification',
            icon: 'child_verification',
            hasArrow: true,
            onTap: () {
              // Handle child verification
            },
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
