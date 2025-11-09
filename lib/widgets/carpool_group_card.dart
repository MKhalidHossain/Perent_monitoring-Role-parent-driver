import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/widgets/group_detailItem.dart';
import 'package:flutter/material.dart';

class CarpoolGroupCard extends StatelessWidget {
  const CarpoolGroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
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
          // Route Icon
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(IconPath.groupIcon, width: 20, height: 20),
          ),
          const SizedBox(width: 16),

          // Group Details
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route A – Morning Pickup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GroupDetailItem(
                        icon: Icons.access_time,
                        label: 'Departure Time',
                        value: '09:00 Pm',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GroupDetailItem(
                        icon: Icons.person,
                        label: 'Assigned Driver',
                        value: 'Driver Sam',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GroupDetailItem(
                        icon: Icons.group,
                        label: 'Total Riders',
                        value: '4 Students',
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
}
