import 'package:bbpool/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/models/ride_model.dart';

class CommonWidgets {
  // Reusable Gradient Button Widget
  static Widget buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    Color? color, // Base color for fallback if no gradient is provided
    double? width,
    double? height,
    double? fontSize,
    FontWeight? fontWeight,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Gradient? gradient, // Optional gradient property
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 56,
        decoration: BoxDecoration(
          color: gradient == null ? (color ?? AppColors.gradientButtonEnd) : null,
          gradient:
              gradient ?? (color == null ? AppColors.gradientButton : null),
          borderRadius: BorderRadius.circular(borderRadius ?? 28),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColors.textPrimary,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Status Bar Widget
  static Widget buildStatusBar(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Container(
            width: 126,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          const Row(
            children: [
              Icon(
                Icons.signal_cellular_4_bar,
                color: AppColors.textPrimary,
                size: 16,
              ),
              SizedBox(width: 4),
              Icon(
                Icons.wifi,
                color: AppColors.textPrimary,
                size: 16,
              ),
              SizedBox(width: 4),
              Icon(
                Icons.battery_6_bar,
                color: AppColors.textPrimary,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Action Button Widget
  static Widget buildActionButton(IconData icon, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }

  // Header Section Widget
  static Widget buildHeaderSection({
    VoidCallback? onChatPressed,
    VoidCallback? onNotificationPressed,
    VoidCallback? onSettingsPressed,
    VoidCallback? onProfileTap,
    bool showBack = false,
    VoidCallback? onBackPressed,
    String? profileImagePath,
    String? chatIconPath,
    String? notificationIconPath,
    String? settingsIconPath,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
    required BuildContext context,
  }) {
    return Container(
      padding: padding,
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          if (showBack) const SizedBox(width: 4),
          // Profile Image
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              padding: const EdgeInsets.all(4),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(30),
                image: profileImagePath != null && profileImagePath.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(profileImagePath),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: profileImagePath == null || profileImagePath.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 30,
                    )
                  : null,
            ),
          ),
          const Spacer(),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _circleIconButton(
                iconPath: chatIconPath,
                fallbackIcon: Icons.chat_bubble_outline,
                onPressed: onChatPressed ??
                    () => Navigator.pushNamed(
                          context,
                          AppRoutes.driverProfileSetup,
                        ),
              ),
              const SizedBox(width: 10),
              _circleIconButton(
                iconPath: notificationIconPath,
                fallbackIcon: Icons.notifications_outlined,
                onPressed: onNotificationPressed,
              ),
              const SizedBox(width: 10),
              _circleIconButton(
                iconPath: settingsIconPath,
                fallbackIcon: Icons.settings_outlined,
                onPressed: onSettingsPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _circleIconButton({
    String? iconPath,
    IconData? fallbackIcon,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: iconPath != null && iconPath.isNotEmpty
              ? Image.asset(iconPath, width: 45, height: 45)
              : Icon(
                  fallbackIcon ?? Icons.circle_outlined,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
        ),
      ),
    );
  }

  // User Info Section Widget
  static Widget buildUserInfoSection(String userName, String credits) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                userName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              credits,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Header Widget
  static Widget buildSectionHeader(String title,
      {VoidCallback? onFilterPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onFilterPressed != null)
            GestureDetector(
              onTap: onFilterPressed,
              child: const Icon(
                Icons.tune,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  // Ride Card Widget
  static Widget buildRideCard(RideModel ride) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status Indicator
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ride.status == RideStatus.completed
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              ride.status == RideStatus.completed
                  ? Icons.check
                  : Icons.schedule,
              color: ride.status == RideStatus.completed
                  ? Colors.white
                  : AppColors.textSecondary,
              size: 20,
            ),
          ),

          const SizedBox(width: 16),

          // Vehicle Icon
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_bus,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Ride Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ride.type == RideType.departure
                          ? 'Departure Time'
                          : 'Arrival Time',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ride.type == RideType.departure
                      ? ride.departureTime
                      : ride.arrivalTime,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Driver Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Assigned Driver',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                ride.assignedDriver,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Track Ride Button Widget
  static Widget buildTrackRideButton({VoidCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.gradientButton,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Track Ride',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Stat Card Widget
  static Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Monthly Stats Grid Widget
  static Widget buildMonthlyStatsGrid(MonthlyStatsModel? stats) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Stats',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  icon: Icons.directions_car,
                  title: 'Rides Completed',
                  value: '${stats?.ridesCompleted ?? 0} Rides',
                  color: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildStatCard(
                  icon: Icons.schedule,
                  title: 'On-Time Pickups',
                  value: stats?.onTimePercentage ?? '0%',
                  color: const Color(0xFF2196F3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  icon: Icons.event,
                  title: 'Scheduled Rides',
                  value: '${stats?.scheduledRides ?? 0} Rides',
                  color: const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildStatCard(
                  icon: Icons.group,
                  title: 'Active Carpool Groups',
                  value: '${stats?.activeCarpoolGroups ?? 0}',
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
