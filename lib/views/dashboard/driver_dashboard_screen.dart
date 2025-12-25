import 'package:bbpool/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';
import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:bbpool/config/icon_path.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  // Static data matching the image perfectly
  final List<RideModel> _todayRides = [
    RideModel(
      id: '1',
      departureTime: '02:00 Pm',
      arrivalTime: '02:30 Pm',
      ridersCount: 4,
      driverName: 'Jakir Hossain',
      status: 'scheduled',
      vehicleType: 'van',
      isArrived: true,
    ),
    RideModel(
      id: '2',
      departureTime: '02:00 Pm',
      arrivalTime: '02:30 Pm',
      ridersCount: 5,
      driverName: 'Jakir Hossain',
      status: 'scheduled',
      vehicleType: 'van',
      isArrived: false,
    ),
  ];

  final List<StatModel> _monthlyStats = [
    StatModel(
      title: 'Rides Completed',
      value: '53 Rides',
      icon: 'rides_completed',
      color: '#FFA500',
    ),
    StatModel(
      title: 'On-Time Pickups',
      value: '94%',
      icon: 'on_time_pickups',
      color: '#00C853',
    ),
    StatModel(
      title: 'Distance Traveled',
      value: '321 Km',
      icon: 'distance_traveled',
      color: '#2196F3',
    ),
    StatModel(
      title: 'Children Dropped',
      value: '02',
      icon: 'children_dropped',
      color: '#9C27B0',
    ),
    StatModel(
      title: 'Cancellations',
      value: '13',
      icon: 'cancellations',
      color: '#F44336',
    ),
    StatModel(
      title: 'Active Carpool Groups',
      value: '01',
      icon: 'active_carpool_groups',
      color: '#00BCD4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate refresh
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                CommonWidgets.buildHeaderSection(
                  context: context,
                  profileImagePath: IconPath.profileIcon,
                  chatIconPath: IconPath.chatIcon,
                  notificationIconPath: IconPath.notificationIcon,
                  settingsIconPath: IconPath.settingsIcon,
                  onProfileTap: () =>
                      Navigator.pushNamed(context, AppRoutes.driverProfile),
                  onChatPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.messageList),
                  onNotificationPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.notifications),
                  onSettingsPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.settings),
                ),

                const SizedBox(height: 24),

                // Today Rides Section with perfect design
                TodayRidesSection(
                  rides: _todayRides,
                  isDriver: true,
                  onFilterTap: () {
                    // Show filter options
                    _showFilterDialog();
                  },
                  onStartRideTap: () {
                    // Start ride
                    _showStartRideDialog();
                  },
                ),
                const SizedBox(height: 32),

                // Monthly Stats Section
                MonthlyStatsSection(
                  stats: _monthlyStats,
                ),
                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Rides'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Today'),
              onTap: () {
                Navigator.pop(context);
                // Apply today filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('This Week'),
              onTap: () {
                Navigator.pop(context);
                // Apply week filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('This Month'),
              onTap: () {
                Navigator.pop(context);
                // Apply month filter
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStartRideDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start '),
        content: const Text('Are you ready to start the ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ride started!')),
              );
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }


}
