import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/services/parent_service.dart';
import 'package:bbpool/services/storage_service.dart';

class ParentViewModel {
  // State
  bool _isLoading = false;
  String _errorMessage = '';
  List<RideModel> _scheduledRides = [];
  List<RideModel> _calendarRides = [];
  String _selectedMonth = '';
  int _selectedDay = 0;
  String _userName = '';
  String? _profileImageUrl;
  int _credits = 0;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<RideModel> get scheduledRides => _scheduledRides;
  List<RideModel> get calendarRides => _calendarRides;
  String get selectedMonth => _selectedMonth;
  int get selectedDay => _selectedDay;
  String get userName => _userName;
  String? get profileImageUrl => _profileImageUrl;
  int get credits => _credits;

  // Initialize parent view model
  Future<void> initialize() async {
    try {
      _isLoading = true;
      _errorMessage = '';

      // Get user data from storage
      final userData = StorageService.getUserData();
      if (userData != null) {
        _userName = userData['name'] ?? '';
        _profileImageUrl = userData['profile_image'] ?? userData['avatar']?['url'];
        _credits = userData['credit'] ?? 0;
      }

      // Set current month and day
      final now = DateTime.now();
      _selectedMonth = _getMonthName(now.month);
      _selectedDay = now.day;

      // Load scheduled rides for current month
      await loadScheduledRides(month: _selectedMonth);
    } catch (e) {
      _errorMessage = 'Failed to initialize: ${e.toString()}';
      print('ParentViewModel initialize error: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Load scheduled rides
  Future<void> loadScheduledRides({String? month, String? date}) async {
    try {
      _isLoading = true;
      _errorMessage = '';

      final response = await ParentService.getScheduledRides(
        month: month ?? _selectedMonth,
        date: date,
      );

      if (response.success && response.data != null) {
        _scheduledRides = response.data!;
      } else {
        _errorMessage = response.message;
        _scheduledRides = [];
      }
    } catch (e) {
      _errorMessage = 'Failed to load scheduled rides: ${e.toString()}';
      _scheduledRides = [];
      print('ParentViewModel loadScheduledRides error: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Load calendar rides for a specific month
  Future<void> loadCalendarRides({required String month, int? year}) async {
    try {
      _isLoading = true;
      _errorMessage = '';

      final response = await ParentService.getCalendarRides(
        month: month,
        year: year,
      );

      if (response.success && response.data != null) {
        _calendarRides = response.data!;
      } else {
        _errorMessage = response.message;
        _calendarRides = [];
      }
    } catch (e) {
      _errorMessage = 'Failed to load calendar rides: ${e.toString()}';
      _calendarRides = [];
      print('ParentViewModel loadCalendarRides error: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Set selected month
  void setSelectedMonth(String month) {
    _selectedMonth = month;
    loadScheduledRides(month: month);
  }

  // Set selected day
  void setSelectedDay(int day) {
    _selectedDay = day;
    final dateString = '$_selectedMonth $_selectedDay';
    loadScheduledRides(month: _selectedMonth, date: dateString);
  }

  // Cancel a ride
  Future<bool> cancelRide(String rideId, {String? reason}) async {
    try {
      _isLoading = true;
      _errorMessage = '';

      final response = await ParentService.cancelRide(
        rideId: rideId,
        reason: reason,
      );

      if (response.success) {
        // Remove cancelled ride from list
        _scheduledRides.removeWhere((ride) => ride.id == rideId);
        return true;
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to cancel ride: ${e.toString()}';
      print('ParentViewModel cancelRide error: $e');
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Schedule a new ride
  Future<bool> scheduleRide({
    required String childId,
    required String departureTime,
    required String arrivalTime,
    required String pickupLocation,
    required String dropoffLocation,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = '';

      final response = await ParentService.scheduleRide(
        childId: childId,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
        notes: notes,
      );

      if (response.success && response.data != null) {
        // Add new ride to scheduled rides
        _scheduledRides.add(response.data!);
        return true;
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to schedule ride: ${e.toString()}';
      print('ParentViewModel scheduleRide error: $e');
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Track a ride
  Future<Map<String, dynamic>?> trackRide(String rideId) async {
    try {
      _isLoading = true;
      _errorMessage = '';

      final response = await ParentService.trackRide(rideId: rideId);

      if (response.success && response.data != null) {
        return response.data;
      } else {
        _errorMessage = response.message;
        return null;
      }
    } catch (e) {
      _errorMessage = 'Failed to track ride: ${e.toString()}';
      print('ParentViewModel trackRide error: $e');
      return null;
    } finally {
      _isLoading = false;
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await loadScheduledRides(month: _selectedMonth);
  }

  // Get month name from month number
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
  }
}

