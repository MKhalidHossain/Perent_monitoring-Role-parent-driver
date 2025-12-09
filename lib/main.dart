import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/providers/select_user_type_provider.dart';
import 'package:bbpool/providers/dashboard_provider.dart';
import 'package:bbpool/controllers/message_controller.dart';
import 'package:bbpool/controllers/notification_controller.dart';
import 'package:bbpool/controllers/settings_controller.dart';
import 'package:bbpool/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:bbpool/config/app_theme.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/providers/onboarding_provider.dart';
import 'package:bbpool/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const BBPoolApp());
}

class BBPoolApp extends StatelessWidget {
  const BBPoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(context)),
        ChangeNotifierProvider(
            create: (context) => OnboardingProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => SelectUserTypeProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => MessageController()),
        ChangeNotifierProvider(create: (context) => NotificationController()),
        ChangeNotifierProvider(create: (context) => SettingsController()),
        ChangeNotifierProvider(create: (context) => MapController()),

        // Add other providers here as needed
      ],
      child: GetMaterialApp(
        title: 'BBPool',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        // home: const DriverPreTripChecklistScreen(),
      ),
    );
  }
}
