import 'dart:convert';
import 'package:bbpool/config/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:bbpool/models/api_response.dart';
import 'package:bbpool/models/user_model.dart';
import 'package:bbpool/models/login_response_model.dart';
import 'package:bbpool/utils/auth_utils.dart';

class ApiService {

  static const Duration timeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> _getAuthHeaders(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  // Get auth headers from token
  static Map<String, String> get authHeaders => AuthUtils.getAuthHeaders();

  // Generic HTTP methods
  static Future<ApiResponse<T>> _handleRequest<T>(
    Future<http.Response> request,
    T Function(dynamic)? fromJson,
  ) async {
    try {
      final response = await request.timeout(timeout);
      
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');
      
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      return ApiResponse<T>(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: responseData['message'] ?? 'Request failed',
        data: responseData['data'] != null && fromJson != null 
            ? fromJson(responseData['data']) 
            : responseData['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('API Error: $e');
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Auth endpoints
  static Future<ApiResponse<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    return _handleRequest<LoginResponseModel>(
      http.post(
        Uri.parse(AppUrl.login),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ),
      (data) => LoginResponseModel.fromJson(data),
    );
  }

  static Future<ApiResponse<UserModel>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    final requestBody = {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
    
    print('API Registration Request:');
    print('URL: ${AppUrl.register}');
    print('Headers: $_headers');
    print('Body: ${json.encode(requestBody)}');
    
    return _handleRequest<UserModel>(
      http.post(
        Uri.parse(AppUrl.register),
        headers: _headers,
        body: json.encode(requestBody),
      ),
      (data) => UserModel.fromJson(data),
    );
  }

  static Future<ApiResponse<bool>> sendOtp({
    required String email,
  }) async {
    return _handleRequest<bool>(
        http.post(
          Uri.parse(AppUrl.sendOtp),
        headers: _headers,
        body: json.encode({
          'email': email,
        }),
      ),
      (data) {
        // Handle different data types that might be returned
        if (data is bool) {
          return data;
        } else if (data is String) {
          // Convert string to bool (e.g., "true" -> true, "false" -> false)
          return data.toLowerCase() == 'true';
        } else if (data is int) {
          // Convert int to bool (0 -> false, anything else -> true)
          return data != 0;
        } else {
          // Default to false if we can't determine the type
          print('Warning: Unknown data type for send OTP: ${data.runtimeType}');
          return false;
        }
      },
    );
  }

  static Future<ApiResponse<bool>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final requestBody = {
      'email': email,
      'otp': otp,
    };
    
    print('API OTP Verification Request:');
    print('URL: ${AppUrl.verifyEmail}');
    print('Headers: $_headers');
    print('Body: ${json.encode(requestBody)}');
    
    return _handleRequest<bool>(
      http.post(
        Uri.parse(AppUrl.verifyEmail),
        headers: _headers,
        body: json.encode(requestBody),
      ),
      (data) {
        // Handle different data types that might be returned
        if (data is bool) {
          return data;
        } else if (data is String) {
          // Convert string to bool (e.g., "true" -> true, "false" -> false)
          return data.toLowerCase() == 'true';
        } else if (data is int) {
          // Convert int to bool (0 -> false, anything else -> true)
          return data != 0;
        } else {
          // Default to false if we can't determine the type
          print('Warning: Unknown data type for OTP verification: ${data.runtimeType}');
          return false;
        }
      },
    );
  }

  static Future<ApiResponse<UserModel>> getProfile({
    required String token,
  }) async {
    return _handleRequest<UserModel>(
      http.get(
        Uri.parse(AppUrl.profile),
        headers: _getAuthHeaders(token),
      ),
      (data) => UserModel.fromJson(data),
    );
  }

  static Future<ApiResponse<UserModel>> updateProfile({
    required String token,
    required String name,
    required String phone,
    String? profileImage,
  }) async {
    return _handleRequest<UserModel>(
      http.put(
        Uri.parse(AppUrl.updateProfile),
        headers: _getAuthHeaders(token),
        body: json.encode({
          'name': name,
          'phone': phone,
          'profile_image': profileImage,
        }),
      ),
      (data) => UserModel.fromJson(data),
    );
  }

  // Google Sign In
  static Future<ApiResponse<UserModel>> googleSignIn({
    required String googleToken,
  }) async {
    return _handleRequest<UserModel>(
      http.post(
        Uri.parse(AppUrl.googleSignIn),
        headers: _headers,
        body: json.encode({
          'google_token': googleToken,
        }),
      ),
      (data) => UserModel.fromJson(data),
    );
  }

  // Apple Sign In
  static Future<ApiResponse<UserModel>> appleSignIn({
    required String appleToken,
  }) async {
    return _handleRequest<UserModel>(
      http.post(
        Uri.parse(AppUrl.appleSignIn),
        headers: _headers,
        body: json.encode({
          'apple_token': appleToken,
        }),
      ),
      (data) => UserModel.fromJson(data),
    );
  }
}
