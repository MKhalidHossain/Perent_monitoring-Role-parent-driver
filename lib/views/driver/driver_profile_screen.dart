import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Driver Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Profile Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(IconPath.profileIcon),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Driver Sam',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_outline,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '4.97 • 223 Ratings',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CommonWidgets.buildGradientButton(
                    text: 'Inbox me',
                    onPressed: () {},
                  ),

                  // Container(
                  //   width: double.infinity,
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       colors: [Color(0xFFB39DDB), Color(0xFF9C88FF)],
                  //       begin: Alignment.centerLeft,
                  //       end: Alignment.centerRight,
                  //     ),
                  //     borderRadius: BorderRadius.circular(25),
                  //   ),
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Inbox me',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Driver Stats Section
            const Text(
              'Driver Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: '🚗',
                    title: 'Rides Completed',
                    value: '53 Rides',
                    backgroundColor: const Color(0xFFF5F5F5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: '⏰',
                    title: 'On-Time Pickups',
                    value: '94%',
                    backgroundColor: const Color(0xFFF5F5F5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: '🚫',
                    title: 'Cancellations',
                    value: '13',
                    backgroundColor: const Color(0xFFF5F5F5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: '👥',
                    title: 'Children Dropped',
                    value: '02',
                    backgroundColor: const Color(0xFFF5F5F5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Rating & Reviews Section
            const Text(
              'Rating & Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating Summary
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4.97',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        '200 Reviews',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating Breakdown
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.8, '80%'),
                      _buildRatingBar(4, 0.85, '85%'),
                      _buildRatingBar(3, 0.9, '90%'),
                      _buildRatingBar(2, 0.8, '80%'),
                      _buildRatingBar(1, 0.8, '80%'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Individual Reviews
            _buildReviewCard(
              name: 'Antwon Taylor',
              time: '1 month ago',
              rating: 4.0,
              review:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet gravida nulla.',
              avatar:
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=50&h=50&fit=crop&crop=face',
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              name: 'Jamie Scott',
              time: '2 months ago',
              rating: 5.0,
              review:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet gravida nulla.',
              avatar:
                  'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=50&h=50&fit=crop&crop=face',
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              name: 'Nathan Scott',
              time: '3 months ago',
              rating: 3.0,
              review:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet gravida nulla.',
              avatar:
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=50&h=50&fit=crop&crop=face',
            ),
            const SizedBox(height: 20),

            // Read More Button
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB39DDB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Read More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB39DDB), Color(0xFF9C88FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home_outlined, false),
            _buildBottomNavItem(Icons.calendar_today_outlined, false),
            const SizedBox(width: 56), // Space for FAB
            _buildBottomNavItem(Icons.people_outline, true),
            _buildBottomNavItem(Icons.location_on_outlined, false),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
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

  Widget _buildRatingBar(int stars, double percentage, String percentageText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C88FF),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            percentageText,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String time,
    required double rating,
    required String review,
    required String avatar,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.white),
                    const SizedBox(width: 2),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Icon(
        icon,
        size: 24,
        color: isActive ? const Color(0xFF9C88FF) : Colors.grey,
      ),
    );
  }
}
