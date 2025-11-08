import 'dart:math';

import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';
import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/config/icon_path.dart';

class DriverCalendarScreen extends StatefulWidget {
  const DriverCalendarScreen({super.key});

  @override
  State<DriverCalendarScreen> createState() => _DriverCalendarScreenState();
}

class _DriverCalendarScreenState extends State<DriverCalendarScreen> {
  int _currentIndex = 1; // Calendar tab selected
  String _selectedMonth = 'August';
  int _selectedDay = 27;

  final List<String> _months = [
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

  final List<Map<String, dynamic>> _weekDays = [
    {'day': 'Wed', 'date': 1},
    {'day': 'Thu', 'date': 2},
    {'day': 'Fri', 'date': 3},
    {'day': 'Sat', 'date': 4},
    {'day': 'Sun', 'date': 5},
    {'day': 'Mon', 'date': 6},
    {'day': 'Tue', 'date': 7},
    {'day': 'Wed', 'date': 8},
    {'day': 'Thu', 'date': 9},
    {'day': 'Fri', 'date': 10},
    {'day': 'Sat', 'date': 11},
    {'day': 'Sun', 'date': 12},
    {'day': 'Mon', 'date': 13},
    {'day': 'Tue', 'date': 14},
    {'day': 'Wed', 'date': 15},
    {'day': 'Thu', 'date': 16},
    {'day': 'Fri', 'date': 17},
    {'day': 'Sat', 'date': 18},
    {'day': 'Sun', 'date': 19},
    {'day': 'Mon', 'date': 20},
    {'day': 'Tue', 'date': 21},
    {'day': 'Wed', 'date': 22},
    {'day': 'Thu', 'date': 23},
    {'day': 'Fri', 'date': 24},
    {'day': 'Sat', 'date': 25},
    {'day': 'Sun', 'date': 26},
    {'day': 'Mon', 'date': 27},
    {'day': 'Tue', 'date': 28},
    {'day': 'Wed', 'date': 29},
    {'day': 'Thu', 'date': 30},
    {'day': 'Fri', 'date': 31},
  ];

  final List<RideModel> _scheduledRides = [
    RideModel(
      id: '1',
      departureTime: '02:00 Pm',
      arrivalTime: '02:30 Pm',
      ridersCount: 4,
      driverName: 'Sam Smith',
      status: 'scheduled',
      vehicleType: 'van',
      isArrived: true,
    ),
    RideModel(
      id: '2',
      departureTime: '02:00 Pm',
      arrivalTime: '02:30 Pm',
      ridersCount: 5,
      driverName: 'Sam Smith',
      status: 'scheduled',
      vehicleType: 'van',
      isArrived: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              DashboardHeader(
                userName: "Jakir Hossain",
                profileImageUrl: null,
                credits: 100,
                onProfileTap: () {
                  Navigator.pushNamed(context, AppRoutes.driverProfile);
                },
                onChatTap: () {
                  Navigator.pushNamed(context, AppRoutes.messageList);
                },
                onNotificationTap: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
                onSettingsTap: () {
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),
              const SizedBox(height: 24),

              // Month Selector and View Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Month Dropdown
                    GestureDetector(
                      onTap: _showMonthSelector,
                      child: Row(
                        children: [
                          Text(
                            _selectedMonth,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    // View Options

                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Week Calendar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _weekDays.map((dayData) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _buildDayItem(
                          dayData['day'],
                          dayData['date'],
                          dayData['date'] == _selectedDay,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Scheduled Rides Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scheduled Rides',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ride Cards
                    ..._scheduledRides
                        .map((ride) => _buildScheduledRideCard(ride, _scheduledRides.indexOf(ride), _scheduledRides.length)),

                    const SizedBox(height: 20),

                    // Cancel Ride Button
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: _showCancelRideDialog,
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFFFF6B6B),
                    //       padding: const EdgeInsets.symmetric(vertical: 18),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(16),
                    //       ),
                    //       elevation: 0,
                    //     ),
                    //     child: const Text(
                    //       'Cancel Ride',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    CommonWidgets.buildGradientButton(
                      color: AppColors.red,
                      text: 'Cancel Ride',
                      onPressed: () async {
                        // Navigation is now handled in the viewmodel based on user role
                      },
                      textColor: AppColors.textWhite,
                      borderRadius: 28,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Carpool Group Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Carpool Group details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCarpoolGroupCard(),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildViewOption(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8A2BE2) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey[600],
        size: 18,
      ),
    );

  }

  Widget _buildDayItem(String day, int date, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = date;
        });
      },
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? AppColors.buttonGradient // Use the gradient if selected
              : null, // No gradient if not selected
          color: !isSelected ? Colors.transparent : null, // Transparent background if not selected
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledRideCard(RideModel ride, int index, int totalRides) {
    final bool isDeparture = index == 0;

    // Icons & colors
    final IconData leadingIcon = isDeparture ? Icons.access_time : Icons.access_time;
    final Color leadingIconColor = isDeparture ? Colors.grey : Colors.grey;
    final Color leadingBg = isDeparture ? Colors.green.withOpacity(0.12) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Timeline column (icon + connector)
          Column(
            children: [
              Container(
                width: 30,
                height: 60,
                decoration: BoxDecoration(
                  color: leadingBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  leadingIcon,
                  color: leadingIconColor,
                  size: 30,
                ),
              ),
              if (index < totalRides - 1)
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Vehicle Image - Flipped for arrival time (left to right)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(isDeparture ? 0 : pi), // Flip horizontally for arrival
                    child: SizedBox(
                      width: 100,
                      height: 70,
                      child: Image.asset(
                        IconPath.busIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Ride Details
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Time block
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  IconPath.timeIcon,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isDeparture ? 'Departure Time' : 'Arrival Time',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isDeparture ? ride.departureTime : ride.arrivalTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Driver block
                            Row(
                              children: [
                                Image.asset(
                                  IconPath.riderIcon, // You might want to use a driver icon here
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Driver',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ride.driverName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // Riders block
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  IconPath.riderIcon,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Riders',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${ride.ridersCount} Students',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCarpoolGroupCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Route Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.route,
              color: Color(0xFFFF6B6B),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Group Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Route A – Morning Pickup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildGroupDetailItem(
                        Icons.access_time,
                        'Departure Time',
                        '09:00 Pm',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildGroupDetailItem(
                        Icons.person,
                        'Assigned Driver',
                        'Driver Sam',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildGroupDetailItem(
                        Icons.group,
                        'Total Riders',
                        '4 Students',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupDetailItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showMonthSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Select Month',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _months.length,
                itemBuilder: (context, index) {
                  final month = _months[index];
                  final isSelected = month == _selectedMonth;
                  return ListTile(
                    title: Text(
                      month,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected ? const Color(0xFF8A2BE2) : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Color(0xFF8A2BE2))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedMonth = month;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Home
        Navigator.pushReplacementNamed(context, AppRoutes.driverDashboard);
        break;
      case 1:
        // Calendar - already here
        break;
      case 2:
        // Groups
        Navigator.pushNamed(context, AppRoutes.groups);
        break;
      case 3:
        // Location
        Navigator.pushNamed(context, AppRoutes.mapScreen);
        break;
    }
  }
}
class TodayRidesSection extends StatelessWidget {
  final List<RideModel> rides;
  final VoidCallback? onFilterTap;
  final VoidCallback? onStartRideTap;
  final VoidCallback? onTrackRideTap;
  final bool isDriver;

  const TodayRidesSection({
    super.key,
    required this.rides,
    this.onFilterTap,
    this.onStartRideTap,
    this.onTrackRideTap,
    this.isDriver = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today Rides',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: onFilterTap,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                  Image.asset(IconPath.filterIcon, width: 16, height: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (rides.isEmpty)
            const Center(
              child: Text(
                'No rides scheduled for today',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Column(
              children: [
                ...rides.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ride = entry.value;
                  return _buildRideCard(ride, index, rides.length);
                }),
                const SizedBox(height: 20),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: isDriver ? onStartRideTap : onTrackRideTap,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFFE8D5F2),
                //       padding: const EdgeInsets.symmetric(vertical: 18),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(16),
                //       ),
                //       elevation: 0,
                //     ),
                //     child: Text(
                //       isDriver ? 'Start Ride1' : 'Track Ride',
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // ),

                CommonWidgets.buildGradientButton(
                  text: isDriver ? 'Start Ride' : 'Track Ride',
                  onPressed: () async {
                    // Navigation is now handled in the viewmodel based on user role
                  },
                  textColor: AppColors.textWhite,
                  borderRadius: 28,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRideCard(RideModel ride, int index, int totalRides) {
    final bool isDeparture = index == 0;

    // Icons & colors
    final IconData leadingIcon =
    isDeparture ? Icons.check_circle : Icons.access_time;
    final Color leadingIconColor = isDeparture ? Colors.green : Colors.grey;
    final Color leadingBg =
    isDeparture ? Colors.green.withOpacity(0.12) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Timeline column (icon + connector)
          Column(
            children: [
              Container(
                width: 30,
                height: 60,
                decoration: BoxDecoration(
                  color: leadingBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  leadingIcon,
                  color: leadingIconColor,
                  size: 30,
                ),
              ),
              if (index < totalRides - 1)
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 70,
                    child: Image.asset(
                      ride.isArrived == true
                          ? IconPath.busIcon
                          : IconPath.busIcon2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Time block
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  IconPath.timeIcon,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isDeparture
                                      ? 'Departure Time'
                                      : 'Arrival Time',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isDeparture
                                  ? ride.departureTime
                                  : ride.arrivalTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        // Riders block
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  IconPath.riderIcon,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Riders',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${ride.ridersCount} Students',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}