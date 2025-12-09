import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/views/driver/driver_ride_detail_screen.dart';
import 'package:bbpool/views/messages/chat_screen.dart';
import 'package:bbpool/views/notifications/notification_screen.dart';
import 'package:bbpool/widgets/carpool_group_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarpoolGroupsScreen extends StatefulWidget {
  const CarpoolGroupsScreen({super.key});

  @override
  State<CarpoolGroupsScreen> createState() => _CarpoolGroupsScreenState();
}

class _CarpoolGroupsScreenState extends State<CarpoolGroupsScreen> {
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
                          child: GestureDetector(
                            onTap: () => Get.to(DriverRideDetailScreen()),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.black54,
                              size: 20,
                            ),
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
