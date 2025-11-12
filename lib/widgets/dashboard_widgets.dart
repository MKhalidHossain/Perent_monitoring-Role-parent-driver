import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/models/dashboard_model.dart';
//
// class DashboardHeader extends StatelessWidget {
//   final String userName;
//   final String? profileImageUrl;
//   final int credits;
//   final VoidCallback? onProfileTap;
//   final VoidCallback? onChatTap;
//   final VoidCallback? onNotificationTap;
//   final VoidCallback? onSettingsTap;
//
//   const DashboardHeader({
//     super.key,
//     required this.userName,
//     this.profileImageUrl,
//     required this.credits,
//     this.onProfileTap,
//     this.onChatTap,
//     this.onNotificationTap,
//     this.onSettingsTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child:
//       Row(
//         children: [
//           GestureDetector(
//             onTap: onProfileTap,
//             child: CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.grey[200],
//               backgroundImage: profileImageUrl != null
//                   ? NetworkImage(profileImageUrl!)
//                   : null,
//               child: profileImageUrl == null
//                   ? Image.asset(IconPath.profileIcon, fit: BoxFit.cover)
//                   : null,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userName,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               _buildActionIcon(
//                 iconPath: IconPath.chatIcon,
//                 onTap: onChatTap,
//                 hasNotification: true,
//               ),
//               const SizedBox(width: 16),
//               _buildActionIcon(
//                 iconPath: IconPath.notificationIcon,
//                 onTap: onNotificationTap,
//               ),
//               const SizedBox(width: 16),
//               _buildActionIcon(
//                 iconPath: IconPath.settingsIcon,
//                 onTap: onSettingsTap,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionIcon({
//     required String iconPath,
//     VoidCallback? onTap,
//     bool hasNotification = false,
//   }) {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Image.asset(iconPath, fit: BoxFit.cover),
//             ),
//           ),
//         ),
//         if (hasNotification)
//           Positioned(
//             right: 2,
//             top: 2,
//             child: Container(
//               width: 12,
//               height: 12,
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

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
              childAspectRatio: 1.6,
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
      padding: const EdgeInsets.all(11),
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
          Row(
            children: [
              _getImage(stat.icon, 26),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  stat.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    // remove overflow from TextStyle (handled above)
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getImage(String iconName, double size ) {
    switch (iconName.toLowerCase()) {
      case 'rides_completed':
        return Image.asset('assets/icons/image 17.png', fit: BoxFit.cover,height: size,width: size,);
      case 'on_time_pickups':
        return Image.asset('assets/icons/image 18.png',fit: BoxFit.cover,height: size,width: size,);
      case 'distance_traveled':
        return Image.asset('assets/icons/image 19.png',fit: BoxFit.cover,height: size,width: size,);
      case 'children_dropped':
        return Image.asset('assets/icons/image 19.png',fit: BoxFit.cover,height: size,width: size,);
      case 'cancellations':
        return Image.asset('assets/icons/image 19.png',fit: BoxFit.cover,height: size,width: size,);
      case 'active_carpool_groups':
        return Image.asset('assets/icons/image 21.png',fit: BoxFit.cover,height: size,width: size,);
      default:
        return Image.asset('assets/icons/image 19.png',fit: BoxFit.cover,height: size,width: size,);
    }
  }

}



