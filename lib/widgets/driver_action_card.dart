import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/views/driver/driver_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A standalone profile-action card that matches the provided design reference.
class DriverActionCard extends StatelessWidget {
  const DriverActionCard({
    super.key,
    this.driverName = 'Driver Sam',
    this.ratingText = '4.97 - 223 Ratings',
    this.avatarPath = IconPath.profileIcon,
    this.onInbox,
    this.onProfile,
  });

  final String driverName;
  final String ratingText;
  final String avatarPath;
  final VoidCallback? onInbox;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(avatarPath),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_border,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ratingText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _pillButton(
                  label: 'Inbox me',
                  onTap: onInbox,
                  gradient: AppColors.gradientButton,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _pillButton(
                  label: 'Driver Profile',
                  onTap: () {
                    Get.to(DriverProfileScreen());
                  },
                  borderColor: const Color(0xFFBDA9E6),
                  textColor: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillButton({
    required String label,
    VoidCallback? onTap,
    LinearGradient? gradient,
    Color? borderColor,
    Color textColor = AppColors.textPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(28),
          border: gradient == null
              ? Border.all(
                  color: borderColor ?? Colors.grey.shade300, width: 1.4)
              : null,
          boxShadow: gradient != null
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
