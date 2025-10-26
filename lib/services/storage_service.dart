import 'package:shared_preferences/shared_preferences.dart';
import 'package:bbpool/config/app_config.dart';
import 'package:bbpool/services/token_manager.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  // Token Management
  static Future<void> saveToken(String token) async {
    await prefs.setString(AppConfig.userTokenKey, token);
  }

  static String? getToken() {
    return prefs.getString(AppConfig.userTokenKey);
  }

  static Future<void> clearToken() async {
    await prefs.remove(AppConfig.userTokenKey);
  }

  // Refresh Token Management
  static Future<void> saveRefreshToken(String refreshToken) async {
    await prefs.setString('refresh_token', refreshToken);
  }

  static String? getRefreshToken() {
    return prefs.getString('refresh_token');
  }

  static Future<void> clearRefreshToken() async {
    await prefs.remove('refresh_token');
  }

  // User Data Management
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await prefs.setString(AppConfig.userDataKey, json.encode(userData));
  }

  static Map<String, dynamic>? getUserData() {
    final userDataString = prefs.getString(AppConfig.userDataKey);
    if (userDataString != null) {
      try {
        return json.decode(userDataString) as Map<String, dynamic>;
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  static Future<void> clearUserData() async {
    await prefs.remove(AppConfig.userDataKey);
  }

  // User Role Management
  static Future<void> saveUserRole(String role) async {
    await prefs.setString('user_role', role);
  }

  static String? getUserRole() {
    return prefs.getString('user_role');
  }

  static Future<void> clearUserRole() async {
    await prefs.remove('user_role');
  }

  // User ID Management
  static Future<void> saveUserId(String userId) async {
    await prefs.setString('user_id', userId);
  }

  static String? getUserId() {
    return prefs.getString('user_id');
  }

  static Future<void> clearUserId() async {
    await prefs.remove('user_id');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await TokenManager.isLoggedIn();
  }

  // Clear all user data (logout)
  static Future<bool> clearAllUserData() async {
    await Future.wait([
      clearToken(),
      clearRefreshToken(),
      clearUserData(),
      clearUserRole(),
      clearUserId(),
    ]);
    return true;
  }

  // Onboarding Management
  static Future<void> setOnboardingCompleted() async {
    await prefs.setBool(AppConfig.onboardingCompletedKey, true);
  }

  static bool isOnboardingCompleted() {
    return prefs.getBool(AppConfig.onboardingCompletedKey) ?? false;
  }

  // Theme Management
  static Future<void> setThemeMode(String themeMode) async {
    await prefs.setString(AppConfig.themeKey, themeMode);
  }

  static String? getThemeMode() {
    return prefs.getString(AppConfig.themeKey);
  }

  // Generic methods for other data
  static Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  static String? getString(String key) {
    return prefs.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return prefs.getBool(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  static Future<void> remove(String key) async {
    await prefs.remove(key);
  }
}
