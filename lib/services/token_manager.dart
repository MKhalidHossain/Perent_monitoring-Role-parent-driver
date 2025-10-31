import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _keyUserData = "userData";
  static const String _keyAccessToken = "accessToken";
  static const String _keyRefreshToken = "refreshToken";
  static const String _keyUserRole = "userRole";
  static const String _keyUserId = "userId";
  static const String _keyUserEmail = "userEmail";

  /// Save all user data to SharedPreferences
  static Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    debugPrint('=== SAVING USER DATA TO SHARED PREFERENCES ===');
    debugPrint('Access Token: ${data['accessToken']}');
    debugPrint('Refresh Token: ${data['refreshToken']}');
    debugPrint('User Role: ${data['role']}');
    debugPrint('User ID: ${data['_id']}');
    debugPrint('User Email: ${data['email']}');
    debugPrint('==============================================');

    await prefs.setString(_keyAccessToken, data['accessToken']);
    await prefs.setString(_keyRefreshToken, data['refreshToken']);
    await prefs.setString(_keyUserRole, data['role']);
    await prefs.setString(_keyUserId, data['_id']);
    await prefs.setString(_keyUserEmail, data['email']);

    await prefs.setString(_keyUserData, jsonEncode(data)); // Full backup
    
    debugPrint('✅ All user data saved successfully to SharedPreferences');
  }

  /// Get complete stored user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_keyUserData);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  /// Access Token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// Refresh Token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  /// User Role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  /// User Id
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// User Email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  /// Check Login Status
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all saved user session data (Logout)
  static Future<bool> clearUserData() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    debugPrint('=== CLEARING ALL USER DATA FROM SHARED PREFERENCES ===');
    debugPrint('Clearing access token, refresh token, user role, user ID, user email, and full backup');
    debugPrint('====================================================');

    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserData);

    debugPrint('✅ All user data cleared successfully from SharedPreferences');
    debugPrint('✅ User is now logged out');
    
    return true;
  } catch (e) {
    debugPrint('❌ Failed to clear user data: $e');
    return false;
  }
}

}
