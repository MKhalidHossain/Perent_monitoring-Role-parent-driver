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
    calendar: (context) => const Scaffold(body: Center(child: Text('Calendar'))),
    groups: (context) => const Scaffold(body: Center(child: Text('Groups'))),
    location: (context) => const Scaffold(body: Center(child: Text('Location'))),
    roleTest: (context) => const RoleTestScreen(),
  };
}
