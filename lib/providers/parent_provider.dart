import 'package:flutter/material.dart';
import 'package:bbpool/viewmodels/parent_viewmodel.dart';
import 'package:bbpool/models/dashboard_model.dart';

class ParentProvider with ChangeNotifier {
  final ParentViewModel _viewModel = ParentViewModel();

  ParentViewModel get viewModel => _viewModel;

  // Getters for easy access
  bool get isLoading => _viewModel.isLoading;
  String get errorMessage => _viewModel.errorMessage;
  List<RideModel> get scheduledRides => _viewModel.scheduledRides;
  List<RideModel> get calendarRides => _viewModel.calendarRides;
  String get selectedMonth => _viewModel.selectedMonth;
  int get selectedDay => _viewModel.selectedDay;
  String get userName => _viewModel.userName;
  String? get profileImageUrl => _viewModel.profileImageUrl;
  int get credits => _viewModel.credits;

  // Initialize parent provider
  Future<void> initialize() async {
    await _viewModel.initialize();
    notifyListeners();
  }

  // Load scheduled rides
  Future<void> loadScheduledRides({String? month, String? date}) async {
    await _viewModel.loadScheduledRides(month: month, date: date);
    notifyListeners();
  }

  // Load calendar rides
  Future<void> loadCalendarRides({required String month, int? year}) async {
    await _viewModel.loadCalendarRides(month: month, year: year);
    notifyListeners();
  }

  // Set selected month
  void setSelectedMonth(String month) {
    _viewModel.setSelectedMonth(month);
    notifyListeners();
  }

  // Set selected day
  void setSelectedDay(int day) {
    _viewModel.setSelectedDay(day);
    notifyListeners();
  }

  // Cancel a ride
  Future<bool> cancelRide(String rideId, {String? reason}) async {
    final result = await _viewModel.cancelRide(rideId, reason: reason);
    notifyListeners();
    return result;
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
    final result = await _viewModel.scheduleRide(
      childId: childId,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      notes: notes,
    );
    notifyListeners();
    return result;
  }

  // Track a ride
  Future<Map<String, dynamic>?> trackRide(String rideId) async {
    return await _viewModel.trackRide(rideId);
  }

  // Refresh data
  Future<void> refresh() async {
    await _viewModel.refresh();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _viewModel.clearError();
    notifyListeners();
  }
}

