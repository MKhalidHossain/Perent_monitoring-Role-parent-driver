import 'package:flutter/material.dart';
import 'package:bbpool/viewmodels/dashboard_viewmodel.dart';
import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/models/user_model.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardViewModel _viewModel = DashboardViewModel();

  DashboardViewModel get viewModel => _viewModel;
  DashboardModel get model => _viewModel.model;

  // Getters for easy access
  List<RideModel> get todayRides => _viewModel.todayRides;
  List<StatModel> get monthlyStats => _viewModel.monthlyStats;
  int get credits => _viewModel.credits;
  String get userName => _viewModel.userName;
  String get userRole => _viewModel.userRole;

  // Initialize dashboard
  Future<void> initializeDashboard(UserModel user) async {
    await _viewModel.initializeDashboard(user);
    notifyListeners();
  }

  // Actions
  Future<void> startRide(String rideId) async {
    await _viewModel.startRide(rideId);
    notifyListeners();
  }

  Future<void> trackRide(String rideId) async {
    await _viewModel.trackRide(rideId);
    notifyListeners();
  }

  Future<void> refreshDashboard() async {
    await _viewModel.refreshDashboard();
    notifyListeners();
  }
}
