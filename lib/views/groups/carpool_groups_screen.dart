import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/views/messages/chat_screen.dart';
import 'package:bbpool/views/notifications/notification_screen.dart';
import 'package:bbpool/widgets/carpool_group_card.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';

class CarpoolGroupsScreen extends StatefulWidget {
  const CarpoolGroupsScreen({super.key});

  @override
  State<CarpoolGroupsScreen> createState() => _CarpoolGroupsScreenState();
}

class _CarpoolGroupsScreenState extends State<CarpoolGroupsScreen> {
  int _currentIndex = 2; // Groups tab is index 2

  // Sample carpool groups data
  final List<CarpoolGroup> _carpoolGroups = const [
    CarpoolGroup(
      id: '1',
      routeName: 'Route A - Morning Pickup',
      departureTime: '07:30 Am',
      assignedDriver: 'Driver Sam',
      totalRiders: 4,
      status: 'Students',
      icon: '🚐',
    ),
    CarpoolGroup(
      id: '2',
      routeName: 'Route C - Afternoon Drop',
      departureTime: '02:00 Pm',
      assignedDriver: 'Alex Sam',
      totalRiders: 22,
      status: 'Students',
      icon: '🚐',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Title with filter icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Carpool Groups',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Carpool Groups List
                    Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return const CarpoolGroupCard();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              child: Image.asset(IconPath.profileIcon)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jakir Hossain',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // _buildActionIcon(Icons.chat_bubble_outline),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatScreen(
                                userId: '1',
                                userName: 'Jakir Hossain',
                                userAvatar: '',
                                isOnline: false)));
                  },
                  child: Image.asset(IconPath.chatIcon, width: 44, height: 44)),
              const SizedBox(width: 16),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                  },
                  child: Image.asset(IconPath.notificationIcon,
                      width: 44, height: 44)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarpoolGroupCard(CarpoolGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.driverDashboardCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route name with icon
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    group.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group.routeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Details row
          Row(
            children: [
              // Departure Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group.departureTime,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Assigned Driver
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Driver',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group.assignedDriver,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Total Riders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Riders',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${group.totalRiders} ${group.status}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Model class for carpool groups
class CarpoolGroup {
  final String id;
  final String routeName;
  final String departureTime;
  final String assignedDriver;
  final int totalRiders;
  final String status;
  final String icon;

  const CarpoolGroup({
    required this.id,
    required this.routeName,
    required this.departureTime,
    required this.assignedDriver,
    required this.totalRiders,
    required this.status,
    required this.icon,
  });
}
