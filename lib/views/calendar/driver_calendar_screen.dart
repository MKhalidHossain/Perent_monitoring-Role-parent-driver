import 'dart:math';

import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/widgets/carpool_group_card.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/models/dashboard_model.dart';
import 'package:bbpool/config/icon_path.dart';

class DriverCalendarScreen extends StatefulWidget {
  const DriverCalendarScreen({super.key});

  @override
  State<DriverCalendarScreen> createState() => _DriverCalendarScreenState();
}

class _DriverCalendarScreenState extends State<DriverCalendarScreen> {
 final int currentIndex = 1; // Calendar tab selected
  String _selectedMonth = 'August';
  int _selectedDay = 27;
  int _selectedView = 0;

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
    {'day': 'Sun', 'date': 25},
    {'day': 'Mon', 'date': 26},
    {'day': 'Tue', 'date': 27},
    {'day': 'Wed', 'date': 28},
    {'day': 'Thu', 'date': 29},
    {'day': 'Fri', 'date': 30},
    {'day': 'Sat', 'date': 31},
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),

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
                    Row(
                      children: [
                        _buildViewOption(
                          Icons.view_agenda_outlined,
                          0,
                        ),
                        const SizedBox(width: 8),
                        _buildViewOption(
                          Icons.list_alt_outlined,
                          1,
                        ),
                        const SizedBox(width: 8),
                        _buildViewOption(
                          Icons.tune,
                          2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Week Calendar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double itemWidth =
                        min(46, (constraints.maxWidth - 6 * 6) / 7);
                    return Row(
                      children: _weekDays.asMap().entries.map((entry) {
                        final dayData = entry.value;
                        final bool isLast = entry.key == _weekDays.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(right: isLast ? 0 : 6),
                          child: _buildDayItem(
                            dayData['day'],
                            dayData['date'],
                            dayData['date'] == _selectedDay,
                            width: itemWidth,
                          ),
                        );
                      }).toList(),
                    );
                  },
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
                    ..._scheduledRides.map((ride) => _buildScheduledRideCard(
                        ride,
                        _scheduledRides.indexOf(ride),
                        _scheduledRides.length,
                        size
                        )),

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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carpool Group details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    CarpoolGroupCard(),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for bottom navigation
            ],
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
      // ),
    );
  }

  // Widget _buildViewOption(IconData icon, bool isSelected) {
  //   return Container(
  //     padding: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: isSelected ? const Color(0xFF8A2BE2) : Colors.grey[100],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Icon(
  //       icon,
  //       color: isSelected ? Colors.white : Colors.grey[600],
  //       size: 18,
  //     ),
  //   );
  //
  // }

  Widget _buildDayItem(String day, int date, bool isSelected,
      {double width = 46}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = date;
        });
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                fontSize: 11,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.toString(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewOption(IconData icon, int index) {
    final bool isSelected = _selectedView == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedView = index;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? const Color(0xFFCFB7F2) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? const Color(0xFF7C5BBD) : Colors.black54,
        ),
      ),
    );
  }

 Widget _buildScheduledRideCard(
  RideModel ride,
  int index,
  int totalRides,
  Size size,
) {
  final double w = size.width;

  // Breakpoints (tweak as you like)
  final bool isTablet = w >= 600;
  final bool isCompact = w < 420; // small phones

  // Scale function (base design width ~390)
  double s(double v) => v * (w / 390).clamp(0.85, isTablet ? 1.35 : 1.15);

  final bool isDeparture = index == 0;

  // Icons & colors
  final IconData leadingIcon = Icons.access_time;
  final Color leadingIconColor = Colors.grey;
  final Color leadingBg = const Color(0xFFF1F1F1);

  // Sizes
  final double outerBottom = s(16);
  final double gap = s(8);
  final double cardPad = s(isTablet ? 16 : 12);

  final double timelineCircle = s(30); // diameter
  final double timelineIconSize = s(22);
  final double connectorH = s(isTablet ? 64 : 50);

  final double vehicleW = s(isTablet ? 140 : 80);
  final double vehicleH = s(isTablet ? 90 : 70);

  TextStyle labelStyle() => TextStyle(
        fontSize: s(10),
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      );

  TextStyle valueStyle({bool bold = true}) => TextStyle(
        fontSize: s(bold ? 16 : 14),
        fontWeight: bold ? FontWeight.bold : FontWeight.w600,
        color: Colors.black,
      );

  Widget infoBlock({
    required String label,
    required String value,
    required String iconPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Image.asset(iconPath, width: s(16), height: s(16)),
            SizedBox(width: s(2)),
            Flexible(
              child: Text(
                label,
                style: labelStyle(
                ),
                overflow: TextOverflow.ellipsis,
                
              ),
            ),
          ],
        ),
        SizedBox(height: s(4)),
        Text(
          value,
          style: valueStyle(bold: label.contains('Time')),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget vehicleImage() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(isDeparture ? 0 : pi),
      child: SizedBox(
        width: vehicleW,
        height: vehicleH,
        child: Image.asset(
          IconPath.busIcon,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget detailsCompact() {
    // Image on top, info blocks wrap nicely on small screens
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: vehicleImage()),
        SizedBox(height: gap),
        Wrap(
          spacing: s(18),
          runSpacing: s(12),
          children: [
            infoBlock(
              label: isDeparture ? 'Departure Time' : 'Arrival Time',
              value: isDeparture ? ride.departureTime : ride.arrivalTime,
              iconPath: IconPath.timeIcon,
            ),
            infoBlock(
              label: 'Assigned Driver',
              value: ride.driverName,
              iconPath: IconPath.riderIcon,
            ),
          ],
        ),
      ],
    );
  }

  Widget detailsWide() {
    // Image left, details to the right (phones/tablets)
    return Row(
      children: [
        vehicleImage(),
        SizedBox(width: s(16)),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: infoBlock(
                  label: isDeparture ? 'Departure Time' : 'Arrival Time',
                  value: isDeparture ? ride.departureTime : ride.arrivalTime,
                  iconPath: IconPath.timeIcon,
                ),
              ),
              SizedBox(width: s(14)),
              Expanded(
                child: infoBlock(
                  label: 'Assigned Driver',
                  value: ride.driverName,
                  iconPath: IconPath.riderIcon,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, AppRoutes.driverRideDetail),
    child: Container(
      margin: EdgeInsets.only(bottom: outerBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column (icon + connector)
          Column(
            children: [
              Container(
                width: timelineCircle,
                height: timelineCircle,
                decoration: BoxDecoration(
                  color: leadingBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E2E2)),
                ),
                child: Icon(
                  leadingIcon,
                  color: leadingIconColor,
                  size: timelineIconSize,
                ),
              ),
              if (index < totalRides - 1)
                Container(
                  width: s(2),
                  height: connectorH,
                  color: Colors.grey[300],
                ),
            ],
          ),
          SizedBox(width: s(16)),

          // Card
          Expanded(
            child: Container(
              padding: EdgeInsets.all(cardPad),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(s(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.10),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isCompact ? detailsCompact() : detailsWide(),
            ),
          ),
        ],
      ),
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
