
import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/views/driver/driver_ride_detail_screen.dart';
import 'package:bbpool/widgets/carpool_group_card.dart';
import 'package:bbpool/widgets/common_widgets.dart';
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
                            onTap: () => Get.to(const DriverRideDetailScreen()),
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
