import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbpool/controllers/map_controller.dart';
import 'package:bbpool/models/map_model.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';
import 'package:bbpool/routes/app_routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _currentIndex = 3; // Location tab selected

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapController>().initializeRide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            DashboardHeader(
              userName: "Jakir Hossain",
              profileImageUrl: null,
              credits: 100,
              onProfileTap: () {
                Navigator.pushNamed(context, AppRoutes.driverProfile);
              },
              onChatTap: () {
                Navigator.pushNamed(context, AppRoutes.messageList);
              },
              onNotificationTap: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
              onSettingsTap: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            
            // Map Content
            Expanded(
              child: Consumer<MapController>(
                builder: (context, mapController, child) {
                  final ride = mapController.currentRide;

                  if (mapController.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF9C88FF),
                      ),
                    );
                  }

                  if (ride == null) {
                    return Stack(
                      children: [
                        // Simulated Map
                        _buildSimulatedMap(),
                        
                        // Map Controls
                        Positioned(
                          top: 20,
                          right: 20,
                          child: _buildMapControls(),
                        ),
                        
                        // Location Button
                        Positioned(
                          bottom: 120,
                          right: 20,
                          child: _buildLocationButton(),
                        ),
                        
                        // No Active Ride Message
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No active ride',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start a ride to see live tracking',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  
                  return Stack(
                    children: [
                      // Map with active ride
                      _buildSimulatedMap(),
                      
                      // Driver Info Card
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: _buildDriverInfoCard(ride),
                      ),
                      
                      // Map Controls
                      Positioned(
                        top: 100,
                        right: 20,
                        child: _buildMapControls(),
                      ),
                      
                      // Location Button
                      Positioned(
                        bottom: 120,
                        right: 20,
                        child: _buildLocationButton(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildDriverInfoCard(MapModel ride) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Driver Profile Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(ride.driverImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Driver Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride.driverName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ride.estimatedTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Message Button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF9C88FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.message,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),

          // Cancel Ride Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                _showCancelRideDialog();
              },
              child: const Text(
                'Cancel Ride',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedMap() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Map background pattern
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: CustomPaint(
              painter: MapPainter(),
              size: Size.infinite,
            ),
          ),

          // Route line
          Positioned(
            left: 50,
            top: 400,
            child: Container(
              width: 300,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF9C88FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Start point
          const Positioned(
            left: 45,
            top: 395,
            child: Icon(
              Icons.radio_button_checked,
              color: Color(0xFF9C88FF),
              size: 14,
            ),
          ),

          // End point
          const Positioned(
            left: 345,
            top: 395,
            child: Icon(
              Icons.location_on,
              color: Color(0xFFFF6B6B),
              size: 20,
            ),
          ),

          // Driver car icon
          const Positioned(
            left: 200,
            top: 390,
            child: Icon(
              Icons.directions_car,
              color: Colors.black,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF9C88FF),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.remove,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.my_location,
        color: Colors.black,
        size: 20,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
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
        onPressed: () {
          // Handle add action
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Home
        Navigator.pushReplacementNamed(context, AppRoutes.driverDashboard);
        break;
      case 1:
        // Calendar
        Navigator.pushReplacementNamed(context, AppRoutes.calendar);
        break;
      case 2:
        // Groups
        Navigator.pushNamed(context, AppRoutes.groups);
        break;
      case 3:
        // Location - already here
        break;
    }
  }

  void _showCancelRideDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Ride'),
          content: const Text('Are you sure you want to cancel this ride?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<MapController>().cancelRide();
              },
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter for map background
class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    // Draw grid lines to simulate map
    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (int i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw some "buildings" or blocks
    final buildingPaint = Paint()..color = Colors.grey[200]!;

    canvas.drawRect(
      const Rect.fromLTWH(100, 200, 80, 60),
      buildingPaint,
    );

    canvas.drawRect(
      const Rect.fromLTWH(250, 150, 100, 80),
      buildingPaint,
    );

    canvas.drawRect(
      const Rect.fromLTWH(150, 350, 120, 70),
      buildingPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
