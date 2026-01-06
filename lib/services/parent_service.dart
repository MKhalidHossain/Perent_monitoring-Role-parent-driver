import 'dart:convert';
import 'package:bbpool/config/app_url.dart';
import 'package:bbpool/models/api_response.dart';
import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/utils/auth_utils.dart';
import 'package:http/http.dart' as http;

class ParentService {
  static const Duration timeout = Duration(seconds: 30);

  // Get auth headers with token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await AuthUtils.getToken();
    if (token == null || token.isEmpty) {
      print('❌ Parent Service: No authentication token found');
      return {
        'Accept': 'application/json',
      };
    }
    
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  // Generic HTTP methods
  static Future<ApiResponse<T>> _handleRequest<T>(
    Future<http.Response> request,
    T Function(dynamic)? fromJson,
  ) async {
    try {
      final response = await request.timeout(timeout);

      print('Parent API Response Status: ${response.statusCode}');
      print('Parent API Response Body: ${response.body}');

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
      print('Parent API Error: $e');
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Get scheduled rides for parent
  static Future<ApiResponse<List<RideModel>>> getScheduledRides({
    String? month,
    String? date,
  }) async {
    final headers = await _getAuthHeaders();
    final queryParams = <String, String>{};
    if (month != null) queryParams['month'] = month;
    if (date != null) queryParams['date'] = date;

    final uri = Uri.parse(AppUrl.parentScheduledRides).replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    return _handleRequest<List<RideModel>>(
      http.get(uri, headers: headers),
      (data) {
        if (data is List) {
          return data.map((ride) => RideModel.fromJson(ride)).toList();
        }
        return [];
      },
    );
  }

  // Get calendar rides for a specific month
  static Future<ApiResponse<List<RideModel>>> getCalendarRides({
    required String month,
    int? year,
  }) async {
    final headers = await _getAuthHeaders();
    final queryParams = <String, String>{
      'month': month,
    };
    if (year != null) queryParams['year'] = year.toString();

    final uri = Uri.parse(AppUrl.parentCalendarRides).replace(
      queryParameters: queryParams,
    );

    return _handleRequest<List<RideModel>>(
      http.get(uri, headers: headers),
      (data) {
        if (data is List) {
          return data.map((ride) => RideModel.fromJson(ride)).toList();
        }
        return [];
      },
    );
  }

  // Cancel a scheduled ride
  static Future<ApiResponse<bool>> cancelRide({
    required String rideId,
    String? reason,
  }) async {
    final headers = await _getAuthHeaders();
    return _handleRequest<bool>(
      http.post(
        Uri.parse(AppUrl.parentCancelRide),
        headers: headers,
        body: json.encode({
          'rideId': rideId,
          'reason': reason,
        }),
      ),
      (data) {
        if (data is bool) return data;
        if (data is String) return data.toLowerCase() == 'true';
        return false;
      },
    );
  }

  // Schedule a new ride for child
  static Future<ApiResponse<RideModel>> scheduleRide({
    required String childId,
    required String departureTime,
    required String arrivalTime,
    required String pickupLocation,
    required String dropoffLocation,
    String? notes,
  }) async {
    final headers = await _getAuthHeaders();
    return _handleRequest<RideModel>(
      http.post(
        Uri.parse(AppUrl.parentScheduleRide),
        headers: headers,
        body: json.encode({
          'childId': childId,
          'departureTime': departureTime,
          'arrivalTime': arrivalTime,
          'pickupLocation': pickupLocation,
          'dropoffLocation': dropoffLocation,
          'notes': notes,
        }),
      ),
      (data) => RideModel.fromJson(data),
    );
  }

  // Track a ride
  static Future<ApiResponse<Map<String, dynamic>>> trackRide({
    required String rideId,
  }) async {
    final headers = await _getAuthHeaders();
    final uri = Uri.parse(AppUrl.parentTrackRide).replace(
      queryParameters: {'rideId': rideId},
    );

    return _handleRequest<Map<String, dynamic>>(
      http.get(uri, headers: headers),
      (data) => data is Map<String, dynamic> ? data : {},
    );
  }

  // Get ride details
  static Future<ApiResponse<RideModel>> getRideDetails({
    required String rideId,
  }) async {
    final headers = await _getAuthHeaders();
    final uri = Uri.parse(AppUrl.parentRideDetails).replace(
      queryParameters: {'rideId': rideId},
    );

    return _handleRequest<RideModel>(
      http.get(uri, headers: headers),
      (data) => RideModel.fromJson(data),
    );
  }
}

