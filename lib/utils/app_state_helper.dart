// Helper class for testing navigation flows
// This can be used to reset app state during development/testing

import 'package:bbpool/services/storage_service.dart';

class AppStateHelper {
  // Reset all app state (useful for testing)
  static Future<void> resetAppState() async {
    await StorageService.clearAllUserData();
    // Note: Onboarding completion status will be reset
    // This simulates a fresh app install
  }
  
  // Simulate first-time user (no onboarding completed)
  static Future<void> simulateFirstTimeUser() async {
    await StorageService.clearAllUserData();
    // Don't set onboarding as completed
  }
  
  // Simulate returning user (onboarding completed but not logged in)
  static Future<void> simulateReturningUser() async {
    await StorageService.clearAllUserData();
    await StorageService.setOnboardingCompleted();
  }
  
  // Simulate logged-in user
  static Future<void> simulateLoggedInUser() async {
    await StorageService.clearAllUserData();
    await StorageService.setOnboardingCompleted();
    await StorageService.saveToken('test_token');
    await StorageService.saveUserData({'id': '1', 'name': 'Test User'});
  }
}
