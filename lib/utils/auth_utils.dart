import 'package:bbpool/services/storage_service.dart';

class AuthUtils {
  // Check if user is authenticated
    static Future<bool> isAuthenticated() async {
      return await StorageService.isLoggedIn();
    }

  // Get current user token
  static Future<String?> getToken() async {
    return  StorageService.getToken();
  }

  // Get current user refresh token
  static String? getRefreshToken() {
    return StorageService.getRefreshToken();
  }

  // Get current user role
  static String? getUserRole() {
    return StorageService.getUserRole();
  }

  // Get current user ID
  static String? getUserId() {
    return StorageService.getUserId();
  }

  // Get current user data
  static Map<String, dynamic>? getUserData() {
    return StorageService.getUserData();
  }

  // Clear all authentication data
  static Future<void> clearAuthData() async {
    await StorageService.clearAllUserData();
  }

  // Check if user has specific role
  static bool hasRole(String role) {
    final userRole = getUserRole();
    return userRole == role;
  }

  // Check if user is driver
  static bool isDriver() {
    return hasRole('driver');
  }

  // Check if user is passenger
  static bool isPassenger() {
    return hasRole('passenger');
  }

  // Get authorization header for API calls
  static Map<String, String> getAuthHeaders() {
    final token = getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
     
  }
}
