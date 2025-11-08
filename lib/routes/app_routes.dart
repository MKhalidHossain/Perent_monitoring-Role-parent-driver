import 'package:bbpool/views/driver/driver_profile_screen.dart';
import 'package:bbpool/views/messages/message_list_screen.dart';
import 'package:bbpool/views/messages/message_demo_screen.dart';
import 'package:bbpool/views/notifications/notification_screen.dart';
import 'package:bbpool/views/settings/settings_screen.dart';
import 'package:bbpool/views/map/map_screen.dart';
import 'package:bbpool/views/calendar/driver_calendar_screen.dart';
import 'package:bbpool/views/groups/carpool_groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/views/splash/splash_screen.dart';
import 'package:bbpool/views/onboarding/onboarding_screen.dart';
import 'package:bbpool/views/auth/login_screen.dart';
import 'package:bbpool/views/auth/signup_screen.dart';
import 'package:bbpool/views/auth/otp_verification_screen.dart';
import 'package:bbpool/views/auth/select_user_type_screen.dart';
import 'package:bbpool/views/auth/auth_wrapper.dart';
import 'package:bbpool/views/dashboard/driver_dashboard_screen.dart';
import 'package:bbpool/views/dashboard/parent_dashboard_screen.dart';
import 'package:bbpool/views/test/role_test_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String selectUserType = '/select-user-type';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String driverProfileSetup = '/driver-profile-setup';
  static const String settings = '/settings';
  static const String authWrapper = '/auth-wrapper';
  static const String driverDashboard = '/driver-dashboard';
  static const String parentDashboard = '/parent-dashboard';
  static const String calendar = '/calendar';
  static const String groups = '/groups';
  static const String location = '/location';
  static const String roleTest = '/role-test';
  static const String driverProfile = '/driver-profile';
  static const String messageList = '/message-list';
  static const String messageDemo = '/message-demo';
  static const String notifications = '/notifications';
  static const String mapScreen = '/map';
  

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    selectUserType: (context) => const SelectUserTypeScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    otpVerification: (context) => const OtpVerificationScreen(),
    authWrapper: (context) => const AuthWrapper(),
    driverDashboard: (context) => const DriverDashboardScreen(),
    parentDashboard: (context) => const ParentDashboardScreen(),
    calendar: (context) => const DriverCalendarScreen(),
    groups: (context) => const CarpoolGroupsScreen(),
    location: (context) =>
        const Scaffold(body: Center(child: Text('Location'))),
    roleTest: (context) => const RoleTestScreen(),
    driverProfile: (context) => const DriverProfileScreen(),
    messageList: (context) => const MessageListScreen(),
    messageDemo: (context) => const MessageDemoScreen(),
    notifications: (context) => const NotificationScreen(),
    mapScreen: (context) => const MapScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
