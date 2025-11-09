import 'package:bbpool/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';
import 'package:bbpool/models/dashboard_model.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  int _currentIndex = 0;

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
                // Header with perfect spacing
                DashboardHeader(
                  userName: "Jakir Hossain",
                  profileImageUrl: null,
                  credits: 100,
                  onProfileTap: () {
                    // Navigate to profile
                    Navigator.pushNamed(context, AppRoutes.driverProfile);
                  },
                  onChatTap: () {
                    // Navigate to chat
                    Navigator.pushNamed(context, AppRoutes.messageList);
                  },
                  onNotificationTap: () {
                    // Navigate to notifications
                    Navigator.pushNamed(context, AppRoutes.notifications);
                  },
                  onSettingsTap: () {
                    // Navigate to settings
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
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
      // bottomNavigationBar: BottomNavigation(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //     _handleNavigation(index);
      //   },
      //   onAddTap: () {
      //     // Handle add button tap
      //     _showAddOptionsDialog();
      //   },
      // ),
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

  // void _showAddOptionsDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Add New'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.add_road),
  //             title: const Text('New Route'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               // Navigate to add route
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.group_add),
  //             title: const Text('New Group'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               // Navigate to add group
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.schedule),
  //             title: const Text('Schedule Ride'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               // Navigate to schedule ride
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // void _handleNavigation(int index) {
  //   switch (index) {
  //     case 0:
  //       // Home - already here
  //       break;
  //     case 1:
  //       // Calendar
  //       Navigator.pushNamed(context, AppRoutes.calendar);
  //       break;
  //     case 2:
  //       // Groups
  //       Navigator.pushNamed(context, AppRoutes.groups);
  //       break;
  //     case 3:
  //       // Location
  //       // Navigator.pushNamed(context, '/location');
  //       Navigator.pushNamed(context, AppRoutes.mapScreen);
  //       break;
  //   }
  // }
}
