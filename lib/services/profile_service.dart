import 'dart:convert';
import 'package:bbpool/config/app_url.dart';
import 'package:bbpool/models/api_response.dart';
import 'package:bbpool/models/profile_model.dart';
import 'package:bbpool/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileService {
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

  // Generic HTTP methods
  static Future<ApiResponse<T>> _handleRequest<T>(
    Future<http.Response> request,
    T Function(dynamic)? fromJson,
  ) async {
    try {
      final response = await request.timeout(timeout);
      
      print('Profile API Response Status: ${response.statusCode}');
      print('Profile API Response Body: ${response.body}');
      
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
      print('Profile API Error: $e');
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Get user profile by ID
  static Future<ApiResponse<ProfileModel>> getProfile({
    required String userId,
  }) async {
    final token = StorageService.getToken();
    if (token == null) {
      return ApiResponse<ProfileModel>(
        success: false,
        message: 'No authentication token found',
        statusCode: 401,
      );
    }

    return _handleRequest<ProfileModel>(
      http.get(
        Uri.parse('${AppUrl.profile}/$userId'),
        headers: _getAuthHeaders(token),
      ),
      (data) => ProfileModel.fromJson(data),
    );
  }

  // Update user profile
  static Future<ApiResponse<ProfileModel>> updateProfile({
    required String location,
    String? avatarImagePath,
  }) async {
    final token = StorageService.getToken();
    if (token == null) {
      return ApiResponse<ProfileModel>(
        success: false,
        message: 'No authentication token found',
        statusCode: 401,
      );
    }

    // Prepare request body
    final requestBody = {
      'location': location,
    };

    // If avatar image is provided, add it to the request
    if (avatarImagePath != null) {
      requestBody['avatar'] = avatarImagePath;
    }

    return _handleRequest<ProfileModel>(
      http.put(
        Uri.parse(AppUrl.updateProfile),
        headers: _getAuthHeaders(token),
        body: json.encode(requestBody),
      ),
      (data) => ProfileModel.fromJson(data),
    );
  }

  // Upload avatar image (if needed for file upload)
  static Future<ApiResponse<String>> uploadAvatar({
    required XFile imageFile,
  }) async {
    final token = StorageService.getToken();
    if (token == null) {
      return ApiResponse<String>(
        success: false,
        message: 'No authentication token found',
        statusCode: 401,
      );
    }

    try {
      // Create multipart request for file upload
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppUrl.baseUrl}/upload/avatar'),
      );
      
      request.headers.addAll(_getAuthHeaders(token));
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        imageFile.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Avatar Upload Response Status: ${response.statusCode}');
      print('Avatar Upload Response Body: ${response.body}');
      
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      return ApiResponse<String>(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: responseData['message'] ?? 'Upload failed',
        data: responseData['data']?['url'] ?? '',
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('Avatar Upload Error: $e');
      return ApiResponse<String>(
        success: false,
        message: 'Upload error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Upload driver profile with multipart form data
  static Future<bool> uploadDriverProfile({
    required String token,
    required String name,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? phone,
    String? imagePath,
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppUrl.baseUrl}/driver/profile/upload'),
      );
      
      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add form fields
      request.fields.addAll({
        'name': name,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
        if (phone != null) 'phone': phone,
      });

      // Add image file if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        try {
          request.files.add(
            await http.MultipartFile.fromPath(
              'avatar',
              imagePath,
            ),
          );
        } catch (e) {
          print('Error adding image file: $e');
        }
      }

      print('Driver Profile Upload Request:');
      print('URL: ${request.url}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('Files: ${request.files.length}');

      // Send request
      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Driver Profile Upload Response Status: ${response.statusCode}');
      print('Driver Profile Upload Response Body: ${response.body}');
      
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Driver Profile Upload Error: $e');
      return false;
    }
  }
}