import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/providers/dashboard_provider.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDashboard();
    });
  }

  void _initializeDashboard() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      dashboardProvider.initializeDashboard(authProvider.currentUser!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer2<AuthProvider, DashboardProvider>(
          builder: (context, authProvider, dashboardProvider, child) {
            if (authProvider.currentUser == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await dashboardProvider.refreshDashboard();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header
                    DashboardHeader(
                      userName: dashboardProvider.userName,
                      profileImageUrl: authProvider.currentUser?.profileImage,
                      credits: dashboardProvider.credits,
                      onProfileTap: () {
                        // Navigate to profile
                      },
                      onChatTap: () {
                        // Navigate to chat
                      },
                      onNotificationTap: () {
                        // Navigate to notifications
                      },
                      onSettingsTap: () {
                        // Navigate to settings
                      },
                    ),

                    const SizedBox(height: 20),

                    // Today Rides Section
                    TodayRidesSection(
                      rides: dashboardProvider.todayRides,
                      isDriver: false,
                      onFilterTap: () {
                        // Show filter options
                        _showFilterDialog();
                      },
                      onTrackRideTap: () {
                        // Track ride
                        if (dashboardProvider.todayRides.isNotEmpty) {
                          dashboardProvider
                              .trackRide(dashboardProvider.todayRides.first.id);
                        }
                      },
                    ),
                    const SizedBox(height: 30),

                    // Monthly Stats Section
                    MonthlyStatsSection(
                      stats: dashboardProvider.monthlyStats,
                    ),
                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Rides'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Today'),
              onTap: () {
                Navigator.pop(context);
                // Apply today filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('This Week'),
              onTap: () {
                Navigator.pop(context);
                // Apply week filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('This Month'),
              onTap: () {
                Navigator.pop(context);
                // Apply month filter
              },
            ),
          ],
        ),
      ),
    );
  }
}
