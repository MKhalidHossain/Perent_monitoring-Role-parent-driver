import 'dart:convert';
import 'dart:io';
import 'package:bbpool/config/app_url.dart';
import 'package:bbpool/models/api_response.dart';
import 'package:bbpool/models/child_info_model.dart';
import 'package:bbpool/services/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ChildInfoService {
  static const Duration timeout = Duration(seconds: 30);


  // Add child info with multipart form data
  static Future<ApiResponse<ChildInfoModel>> addChildInfo({
    required String fullName,
    required String schoolName,
    required String emergencyContactName,
    required String emergencyContactNumber,
    required String relationship,
    DateTime? dateOfBirth,
    String? avatarPath,
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.addChildInfo),
      );

      // Get and validate authentication token from TokenManager
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) {
        print('❌ Child Info Service: No authentication token found');
        return ApiResponse<ChildInfoModel>(
          success: false,
          message: 'No authentication token found. Please login again.',
          statusCode: 401,
        );
      }

      print('✅ Child Info Service: Access Token found, length: ${token.length}');

      // Add headers with authentication token
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      print('📤 Child Info Service: Request headers: ${request.headers}');

      // Add form fields
      request.fields.addAll({
        'fullName': fullName,
        'schoolName': schoolName,
        'emergencyContactName': emergencyContactName,
        'emergencyContactNumber': emergencyContactNumber,
        'relationship': relationship,
      });

      // Add date of birth if provided
      request.fields['dateOfBirth'] = dateOfBirth?.toIso8601String() ?? '';

      // Add avatar file if provided
      if (avatarPath != null && avatarPath.isNotEmpty) {
        try {
          final file = File(avatarPath);
          if (await file.exists()) {
            // Get file extension and determine content type
            final extension = avatarPath.split('.').last.toLowerCase();
            String? contentType;
            
            switch (extension) {
              case 'jpg':
              case 'jpeg':
                contentType = 'image/jpeg';
                break;
              case 'png':
                contentType = 'image/png';
                break;
              case 'gif':
                contentType = 'image/gif';
                break;
              default:
                print('⚠️ Unsupported image format: $extension');
                return ApiResponse<ChildInfoModel>(
                  success: false,
                  message: 'Only images (jpeg, jpg, png) are allowed',
                  statusCode: 400,
                );
            }
            
            // Validate file type (contentType is already set above)
            if (!contentType.contains('jpeg') && !contentType.contains('png')) {
              return ApiResponse<ChildInfoModel>(
                success: false,
                message: 'Only images (jpeg, jpg, png) are allowed',
                statusCode: 400,
              );
            }
            
            print('📤 Adding avatar file: $avatarPath');
            print('📤 Content Type: $contentType');
            print('📤 File Extension: $extension');
            
            // Read file bytes
            final fileBytes = await file.readAsBytes();
            
            // Create multipart file with explicit content type
            final fileWithContentType = http.MultipartFile(
              'avatar',
              Stream.value(fileBytes),
              fileBytes.length,
              filename: 'avatar.$extension',
              contentType: MediaType('image', extension == 'jpg' || extension == 'jpeg' ? 'jpeg' : 'png'),
            );
            
            request.files.add(fileWithContentType);
            print('✅ Avatar file added successfully with content type: ${fileWithContentType.contentType}');
          } else {
            print('❌ File does not exist: $avatarPath');
          }
        } catch (e) {
          print('❌ Error adding avatar file: $e');
          return ApiResponse<ChildInfoModel>(
            success: false,
            message: 'Error processing image file: ${e.toString()}',
            statusCode: 400,
          );
        }
      }

      print('Add Child Info Request:');
      print('URL: ${request.url}');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('Files: ${request.files.length}');

      // Send request
      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      print('Add Child Info Response Status: ${response.statusCode}');
      print('Add Child Info Response Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      ChildInfoModel? childData;
      if (responseData['data'] != null) {
        childData = ChildInfoModel.fromJson(responseData['data']);
      }

      return ApiResponse<ChildInfoModel>(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: responseData['message'] ?? 'Request failed',
        data: childData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('Add Child Info Error: $e');
      return ApiResponse<ChildInfoModel>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Get child info list
  static Future<ApiResponse<List<ChildInfoModel>>> getChildInfo() async {
    try {
      // Get and validate authentication token from TokenManager
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) {
        print('❌ Child Info Service: No authentication token found');
        return ApiResponse<List<ChildInfoModel>>(
          success: false,
          message: 'No authentication token found. Please login again.',
          statusCode: 401,
        );
      }

      print('✅ Child Info Service: Access Token found, length: ${token.length}');
      print('📤 Child Info Service: Fetching child info from: ${AppUrl.getChildInfo}');

      final response = await http.get(
        Uri.parse(AppUrl.getChildInfo),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      print('📥 Child Info Service: Response Status: ${response.statusCode}');
      print('📥 Child Info Service: Response Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<ChildInfoModel> children = [];
        
        if (responseData['data'] != null && responseData['data'] is List) {
          try {
            children = (responseData['data'] as List)
                .map((item) {
                  try {
                    return ChildInfoModel.fromJson(item);
                  } catch (e) {
                    print('❌ Error parsing child item: $e');
                    print('   Item data: $item');
                    return null;
                  }
                })
                .whereType<ChildInfoModel>()
                .toList();
            
            print('✅ Child Info Service: Successfully parsed ${children.length} children');
          } catch (e) {
            print('❌ Error parsing children list: $e');
          }
        }

        return ApiResponse<List<ChildInfoModel>>(
          success: true,
          message: responseData['message'] ?? 'Child info fetched successfully',
          data: children,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse<List<ChildInfoModel>>(
          success: false,
          message: responseData['message'] ?? 'Failed to fetch child info',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Child Info Service Error: $e');
      return ApiResponse<List<ChildInfoModel>>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Update child info with multipart form data (PUT)
  static Future<ApiResponse<ChildInfoModel>> updateChildInfo({
    required String childId,
    required String fullName,
    required String schoolName,
    required String emergencyContactName,
    required String emergencyContactNumber,
    required String relationship,
    DateTime? dateOfBirth,
    String? avatarPath,
  }) async {
    try {
      // Create multipart request for PUT
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(AppUrl.updateChildInfo(childId)),
      );

      // Get and validate authentication token from TokenManager
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) {
        print('❌ Child Info Service: No authentication token found');
        return ApiResponse<ChildInfoModel>(
          success: false,
          message: 'No authentication token found. Please login again.',
          statusCode: 401,
        );
      }

      print('✅ Child Info Service: Access Token found, length: ${token.length}');
      print('📤 Child Info Service: Updating child info: $childId');

      // Add headers with authentication token
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      print('📤 Child Info Service: Request headers: ${request.headers}');

      // Add form fields (same as addChildInfo)
      request.fields.addAll({
        'fullName': fullName,
        'schoolName': schoolName,
        'emergencyContactName': emergencyContactName,
        'emergencyContactNumber': emergencyContactNumber,
        'relationship': relationship,
      });

      // Add date of birth if provided
      request.fields['dateOfBirth'] = dateOfBirth?.toIso8601String() ?? '';

      // Add avatar file if provided
      if (avatarPath != null && avatarPath.isNotEmpty) {
        try {
          final file = File(avatarPath);
          if (await file.exists()) {
            // Get file extension and determine content type
            final extension = avatarPath.split('.').last.toLowerCase();
            String? contentType;
            
            switch (extension) {
              case 'jpg':
              case 'jpeg':
                contentType = 'image/jpeg';
                break;
              case 'png':
                contentType = 'image/png';
                break;
              case 'gif':
                contentType = 'image/gif';
                break;
              default:
                print('⚠️ Unsupported image format: $extension');
                return ApiResponse<ChildInfoModel>(
                  success: false,
                  message: 'Only images (jpeg, jpg, png) are allowed',
                  statusCode: 400,
                );
            }
            
            // Validate file type
            if (!contentType.contains('jpeg') && !contentType.contains('png')) {
              return ApiResponse<ChildInfoModel>(
                success: false,
                message: 'Only images (jpeg, jpg, png) are allowed',
                statusCode: 400,
              );
            }
            
            print('📤 Adding avatar file: $avatarPath');
            print('📤 Content Type: $contentType');
            print('📤 File Extension: $extension');
            
            // Read file bytes
            final fileBytes = await file.readAsBytes();
            
            // Create multipart file with explicit content type
            final fileWithContentType = http.MultipartFile(
              'avatar',
              Stream.value(fileBytes),
              fileBytes.length,
              filename: 'avatar.$extension',
              contentType: MediaType('image', extension == 'jpg' || extension == 'jpeg' ? 'jpeg' : 'png'),
            );
            
            request.files.add(fileWithContentType);
            print('✅ Avatar file added successfully with content type: ${fileWithContentType.contentType}');
          } else {
            print('❌ File does not exist: $avatarPath');
          }
        } catch (e) {
          print('❌ Error adding avatar file: $e');
          return ApiResponse<ChildInfoModel>(
            success: false,
            message: 'Error processing image file: ${e.toString()}',
            statusCode: 400,
          );
        }
      }

      print('Update Child Info Request:');
      print('URL: ${request.url}');
      print('Method: PUT');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');
      print('Files: ${request.files.length}');

      // Send request
      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      print('Update Child Info Response Status: ${response.statusCode}');
      print('Update Child Info Response Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      ChildInfoModel? childData;
      if (responseData['data'] != null) {
        childData = ChildInfoModel.fromJson(responseData['data']);
      }

      return ApiResponse<ChildInfoModel>(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: responseData['message'] ?? 'Request failed',
        data: childData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('Update Child Info Error: $e');
      return ApiResponse<ChildInfoModel>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Delete child info
  static Future<ApiResponse<bool>> deleteChildInfo({
    required String childId,
  }) async {
    try {
      // Get and validate authentication token from TokenManager
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) {
        print('❌ Child Info Service: No authentication token found');
        return ApiResponse<bool>(
          success: false,
          message: 'No authentication token found. Please login again.',
          statusCode: 401,
        );
      }

      print('✅ Child Info Service: Access Token found, length: ${token.length}');
      print('📤 Child Info Service: Deleting child info: $childId');
      print('📤 Child Info Service: URL: ${AppUrl.deleteChildInfo(childId)}');

      final response = await http.delete(
        Uri.parse(AppUrl.deleteChildInfo(childId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      print('📥 Child Info Service: Delete Response Status: ${response.statusCode}');
      print('📥 Child Info Service: Delete Response Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Child Info Service: Child deleted successfully');
        return ApiResponse<bool>(
          success: true,
          message: responseData['message'] ?? 'Child deleted successfully',
          data: true,
          statusCode: response.statusCode,
        );
      } else {
        print('❌ Child Info Service: Delete failed');
        return ApiResponse<bool>(
          success: false,
          message: responseData['message'] ?? 'Failed to delete child',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Child Info Service Delete Error: $e');
      return ApiResponse<bool>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}

