import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/models/user_model.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/providers/dashboard_provider.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:bbpool/widgets/dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initDashboard());
  }

  void _initDashboard() {
    if (_initialized) return;
    _initialized = true;

    final authProvider = context.read<AuthProvider>();
    final dashboardProvider = context.read<DashboardProvider>();
    final user = authProvider.currentUser;

    if (user is UserModel) {
      dashboardProvider.initializeDashboard(user);
      return;
    }

    final fallbackUser = UserModel(
      id: 'driver_1',
      email: 'driver@bbpool.com',
      name: 'Sam Smith',
      username: 'samsmith',
      phone: '+1 000 000 0000',
      role: 'driver',
      credit: 100,
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    dashboardProvider.initializeDashboard(fallbackUser);
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 8),
              TodayRidesSection(
                rides: dashboard.todayRides,
                isDriver: true,
                onStartRideTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.driverPreTripChecklist,
                  );
                },
                onRideTap: (_) {
                  Navigator.pushNamed(context, AppRoutes.driverRideDetail);
                },
              ),
              const SizedBox(height: 24),
              MonthlyStatsSection(stats: dashboard.monthlyStats),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
