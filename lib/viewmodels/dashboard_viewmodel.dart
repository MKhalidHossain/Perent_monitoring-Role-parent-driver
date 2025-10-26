import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/models/user_model.dart';

class DashboardViewModel {
  DashboardModel _model = DashboardModel(
    todayRides: [],
    monthlyStats: [],
    credits: 0,
    userName: '',
    userRole: '',
  );

  DashboardModel get model => _model;

  // Getters
  List<RideModel> get todayRides => _model.todayRides;
  List<StatModel> get monthlyStats => _model.monthlyStats;
  int get credits => _model.credits;
  String get userName => _model.userName;
  String get userRole => _model.userRole;

  // Initialize dashboard data
  Future<void> initializeDashboard(UserModel user) async {
    try {
      // Mock data - replace with actual API calls
      final mockRides = _getMockRides(user.role);
      final mockStats = _getMockStats(user.role);

      _model = DashboardModel(
        todayRides: mockRides,
        monthlyStats: mockStats,
        credits: user.credit ?? 0,
        userName: user.name,
        userRole: user.role,
      );
    } catch (e) {
      // Handle error
      print('Error initializing dashboard: $e');
    }
  }

  // Mock data for rides
  List<RideModel> _getMockRides(String role) {
    if (role == 'driver') {
      return [
        RideModel(
          id: '1',
          departureTime: '02:00 PM',
          arrivalTime: '02:30 PM',
          ridersCount: 4,
          driverName: 'Sam Smith',
          status: 'completed',
          vehicleType: 'van',
        ),
        RideModel(
          id: '2',
          departureTime: '02:30 PM',
          arrivalTime: '03:00 PM',
          ridersCount: 5,
          driverName: 'Sam Smith',
          status: 'pending',
          vehicleType: 'van',
        ),
      ];
    } else {
      // Parent rides
      return [
        RideModel(
          id: '1',
          departureTime: '02:00 PM',
          arrivalTime: '02:30 PM',
          ridersCount: 4,
          driverName: 'Sam Smith',
          status: 'completed',
          vehicleType: 'van',
        ),
        RideModel(
          id: '2',
          departureTime: '02:30 PM',
          arrivalTime: '03:00 PM',
          ridersCount: 5,
          driverName: 'Sam Smith',
          status: 'pending',
          vehicleType: 'van',
        ),
      ];
    }
  }

  // Mock data for stats
  List<StatModel> _getMockStats(String role) {
    if (role == 'driver') {
      return [
        StatModel(
          title: 'Rides Completed',
          value: '53 Rides',
          icon: 'rides_completed',
          color: '#FFA726',
        ),
        StatModel(
          title: 'On-Time Pickups',
          value: '94%',
          icon: 'on_time_pickups',
          color: '#66BB6A',
        ),
        StatModel(
          title: 'Distance Traveled',
          value: '321 Km',
          icon: 'distance_traveled',
          color: '#42A5F5',
        ),
        StatModel(
          title: 'Children Dropped',
          value: '02',
          icon: 'children_dropped',
          color: '#AB47BC',
        ),
        StatModel(
          title: 'Cancellations',
          value: '13',
          icon: 'cancellations',
          color: '#EF5350',
        ),
        StatModel(
          title: 'Active Carpool Groups',
          value: '01',
          icon: 'active_carpool_groups',
          color: '#26A69A',
        ),
      ];
    } else {
      // Parent stats
      return [
        StatModel(
          title: 'Rides Completed',
          value: '53 Rides',
          icon: 'rides_completed',
          color: '#FFA726',
        ),
        StatModel(
          title: 'On-Time Pickups',
          value: '94%',
          icon: 'on_time_pickups',
          color: '#66BB6A',
        ),
        StatModel(
          title: 'Scheduled Rides',
          value: '10 Rides',
          icon: 'scheduled_rides',
          color: '#EF5350',
        ),
        StatModel(
          title: 'Active Carpool Groups',
          value: '01',
          icon: 'active_carpool_groups',
          color: '#26A69A',
        ),
      ];
    }
  }

  // Actions
  Future<void> startRide(String rideId) async {
    // Implement start ride logic
    print('Starting ride: $rideId');
  }

  Future<void> trackRide(String rideId) async {
    // Implement track ride logic
    print('Tracking ride: $rideId');
  }

  Future<void> refreshDashboard() async {
    // Implement refresh logic
    print('Refreshing dashboard');
  }
}
