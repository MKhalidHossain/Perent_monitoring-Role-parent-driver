import 'dart:math';

import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:bbpool/widgets/driver_action_card.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';
import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/providers/parent_provider.dart';
import 'package:provider/provider.dart';

class ParentCalendarScreen extends StatefulWidget {
  const ParentCalendarScreen({super.key});

  @override
  State<ParentCalendarScreen> createState() => _ParentCalendarScreenState();
}

class _ParentCalendarScreenState extends State<ParentCalendarScreen> {
  final int currentIndex = 1; // Calendar tab selected

  // Generate week days dynamically based on current month
  List<Map<String, dynamic>> _generateWeekDays(String month, int selectedDay) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    
    // Get the last day of the month
    final lastDay = DateTime(currentYear, currentMonth + 1, 0);
    
    final weekDays = <Map<String, dynamic>>[];
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    for (int i = 1; i <= lastDay.day; i++) {
      final date = DateTime(currentYear, currentMonth, i);
      weekDays.add({
        'day': dayNames[date.weekday % 7],
        'date': i,
      });
    }
    
    return weekDays;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
      builder: (context, parentProvider, child) {
        final selectedMonth = parentProvider.selectedMonth.isNotEmpty
            ? parentProvider.selectedMonth
            : 'August';
        final selectedDay = parentProvider.selectedDay != 0
            ? parentProvider.selectedDay
            : 27;
        final scheduledRides = parentProvider.scheduledRides;
        final weekDays = _generateWeekDays(selectedMonth, selectedDay);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: parentProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header
                        DashboardHeader(
                          userName: parentProvider.userName.isNotEmpty
                              ? parentProvider.userName
                              : "Jakir Hossain",
                          profileImageUrl: parentProvider.profileImageUrl,
                          credits: parentProvider.credits,
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
                                onTap: () => _showMonthSelector(context, parentProvider),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedMonth,
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
                              children: weekDays.map((dayData) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: _buildDayItem(
                                    context,
                                    parentProvider,
                                    dayData['day'],
                                    dayData['date'],
                                    dayData['date'] == selectedDay,
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
                              if (scheduledRides.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      'No scheduled rides for this date',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ...scheduledRides.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final ride = entry.value;
                                  return _buildScheduledRideCard(
                                    ride,
                                    index,
                                    scheduledRides.length,
                                  );
                                }),

                              if (scheduledRides.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                CommonWidgets.buildGradientButton(
                                  color: AppColors.red,
                                  text: 'Cancel Ride',
                                  onPressed: () async {
                                    if (scheduledRides.isNotEmpty) {
                                      _showCancelRideDialog(
                                        context,
                                        parentProvider,
                                        scheduledRides.first.id,
                                      );
                                    }
                                  },
                                  textColor: AppColors.textWhite,
                                  borderRadius: 28,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Driver Details
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Driver Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              DriverActionCard(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100), // Space for bottom navigation
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }


  Widget _buildDayItem(
    BuildContext context,
    ParentProvider parentProvider,
    String day,
    int date,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        parentProvider.setSelectedDay(date);
      },
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? AppColors.buttonGradient // Use the gradient if selected
              : null, // No gradient if not selected
          color: !isSelected
              ? Colors.transparent
              : null, // Transparent background if not selected
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
    final IconData leadingIcon =
        isDeparture ? Icons.access_time : Icons.access_time;
    final Color leadingIconColor = isDeparture ? Colors.grey : Colors.grey;
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
                    transform: Matrix4.rotationY(
                        isDeparture ? 0 : pi), // Flip horizontally for arrival
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

                            // Driver block
                            Row(
                              children: [
                                Image.asset(
                                  IconPath
                                      .riderIcon, // You might want to use a driver icon here
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
  // Widget _buildCarpoolGroupCard() {
  //   return Container(

  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF4F4F4),
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         // Route Icon
  //         Container(
  //           width: 40,
  //           height: 40,
  //           child: Image.asset(IconPath.groupIcon, width: 20, height: 20),
  //         ),
  //         const SizedBox(width: 16),

  //         // Group Details
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'Route A – Morning Pickup',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: GroupDetailItem(
  //                       icon:
  //                       Icons.access_time,
  //                     label:   'Departure Time',
  //                      value:  '09:00 Pm',
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: GroupDetailItem(
  //                   icon:     Icons.person,
  //                     label:   'Assigned Driver',
  //                   value:    'Driver Sam',
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: GroupDetailItem(
  //                     icon:   Icons.group,
  //                     label:   'Total Riders',
  //                      value:  '4 Students',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );

  // }

  // Widget _buildGroupDetailItem(IconData icon, String label, String value) {
  //   return

  //   Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,

  //     children: [
  //     Row(
  //     crossAxisAlignment: CrossAxisAlignment.baseline,
  //     textBaseline: TextBaseline.alphabetic, // required for baseline alignment
  //     children: [
  //       Icon(icon, size: 12, color: AppColors.gradientButtonEnd),
  //       const SizedBox(width: 4),
  //       Expanded(
  //         child: Text(
  //           label,
  //           style: const TextStyle(
  //             fontSize: 10, // match icon size for clean alignment
  //             color: Colors.grey,
  //             fontWeight: FontWeight.w500,
  //           ),
  //           overflow: TextOverflow.ellipsis,
  //           maxLines: 1,
  //         ),
  //       ),
  //     ],
  //   ),

  //   const SizedBox(height: 2),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black,
  //         ),
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );

  // }

  void _showMonthSelector(BuildContext context, ParentProvider parentProvider) {
    final months = [
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
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  final isSelected = month == parentProvider.selectedMonth;
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
                      parentProvider.setSelectedMonth(month);
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

  void _showCancelRideDialog(
    BuildContext context,
    ParentProvider parentProvider,
    String rideId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride'),
        content: const Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await parentProvider.cancelRide(rideId);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride cancelled successfully')),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      parentProvider.errorMessage.isNotEmpty
                          ? parentProvider.errorMessage
                          : 'Failed to cancel ride',
                    ),
                  ),
                );
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
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

// fast

// widget for group detail item
