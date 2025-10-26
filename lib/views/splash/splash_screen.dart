import 'package:bbpool/config/image_path.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/services/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
 Future.delayed(const Duration(seconds: 2), () {
    _navigateBasedOnUserStatus();
 });
  }

void _navigateBasedOnUserStatus() async {
  final accessToken = await TokenManager.getAccessToken();
  final userRole = await TokenManager.getUserRole();
  final userId = await TokenManager.getUserId();
  final userData = await TokenManager.getUserData();


  print("********************************************************");
  print(userRole);
  print(userId);
  print(userData);
  print("********************************************************");

  if (accessToken != null) {
    if (userRole == 'driver') {
      Navigator.pushReplacementNamed(context, AppRoutes.driverDashboard);
    } else if (userRole == 'parent') {
      Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  } else {
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.logo),
            fit: BoxFit.cover,
          ),
          gradient: AppColors.backgroundGradient,
        ),
      ),
    );
  }
}