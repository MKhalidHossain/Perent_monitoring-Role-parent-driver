import 'package:bbpool/config/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/models/dashboard_model.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;
  final int credits;
  final VoidCallback? onProfileTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.profileImageUrl,
    required this.credits,
    this.onProfileTap,
    this.onChatTap,
    this.onNotificationTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? Image.asset(IconPath.profileIcon, fit: BoxFit.cover)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
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
              _buildActionIcon(
                iconPath: IconPath.chatIcon,
                onTap: onChatTap,
                hasNotification: true,
              ),
              const SizedBox(width: 16),
              _buildActionIcon(
                iconPath: IconPath.notificationIcon,
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 16),
              _buildActionIcon(
                iconPath: IconPath.settingsIcon,
                onTap: onSettingsTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon({
    required String iconPath,
    VoidCallback? onTap,
    bool hasNotification = false,
  }) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(iconPath, fit: BoxFit.cover),
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
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
                  child: Image.asset(IconPath.filterIcon, width: 16, height: 16),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isDriver ? onStartRideTap : onTrackRideTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8D5F2),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isDriver ? 'Start Ride' : 'Track Ride',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRideCard(RideModel ride, int index, int totalRides) {
    return Container(
      
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 12,
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
                    width: 50,
                    height: 50,
                
                    child:  Image.asset(IconPath.busIcon, width: 28, height: 28,),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(IconPath.timeIcon, width: 16, height: 16,),
                                const SizedBox(width: 4),
                                Text(
                                  index == 0 ? 'Departure Time' : 'Arrival Time',
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
                              index == 0 ? ride.departureTime : ride.arrivalTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                                         
                          ],
                        ),
                    Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                          Row(
                            children: [
                              Image.asset(IconPath.riderIcon, width: 16, height: 16,),
                              const SizedBox(width: 4),
                              const     Text(
                              'Riders',
                              style:  TextStyle(
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

class MonthlyStatsSection extends StatelessWidget {
  final List<StatModel> stats;

  const MonthlyStatsSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return _buildStatCard(stat);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(StatModel stat) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconColor(stat.icon).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(stat.icon),
              color: _getIconColor(stat.icon),
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stat.title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'rides_completed':
        return Icons.directions_bus;
      case 'on_time_pickups':
        return Icons.access_time;
      case 'distance_traveled':
        return Icons.location_on;
      case 'children_dropped':
        return Icons.child_care;
      case 'cancellations':
        return Icons.cancel;
      case 'active_carpool_groups':
        return Icons.group;
      case 'scheduled_rides':
        return Icons.calendar_today;
      default:
        return Icons.info;
    }
  }

  Color _getIconColor(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'rides_completed':
        return const Color(0xFFFFA500); // Orange
      case 'on_time_pickups':
        return const Color(0xFF00C853); // Green
      case 'distance_traveled':
        return const Color(0xFF2196F3); // Blue
      case 'children_dropped':
        return const Color(0xFF9C27B0); // Purple
      case 'cancellations':
        return const Color(0xFFF44336); // Red
      case 'active_carpool_groups':
        return const Color(0xFF00BCD4); // Teal
      case 'scheduled_rides':
        return const Color(0xFFF44336); // Red
      default:
        return Colors.grey;
    }
  }
}

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onAddTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0, 'Home'),
          _buildNavItem(Icons.calendar_today, 1, 'Calendar'),
          _buildNavItem(Icons.group, 2, 'Groups'),
          _buildNavItem(Icons.location_on, 3, 'Location'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF8A2BE2) : Colors.grey,
            size: 28,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF8A2BE2),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

}
