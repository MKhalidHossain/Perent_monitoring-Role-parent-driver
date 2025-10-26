import 'package:bbpool/services/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/views/dashboard/driver_dashboard_screen.dart';
import 'package:bbpool/views/dashboard/parent_dashboard_screen.dart';
import 'package:bbpool/routes/app_routes.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print("********************************************************");

        debugPrint('🔍 AuthWrapper: Checking auth status');
        debugPrint('🔍 AuthWrapper: Is loading: ${authProvider.isLoading}');
        debugPrint('🔍 AuthWrapper: Is logged in: ${authProvider.isLoggedIn}');
        debugPrint('🔍 AuthWrapper: Current user: ${authProvider.currentUser}');
        debugPrint('🔍 AuthWrapper: Current user role: ${authProvider.currentUser?.role}');
        debugPrint('🔍 AuthWrapper: Current user id: ${authProvider.currentUser?.id}');
        debugPrint('🔍 AuthWrapper: Current user email: ${authProvider.currentUser?.email}');
        debugPrint('🔍 AuthWrapper: Current user name: ${authProvider.currentUser?.name}');



        // If not logged in, navigate to login
        if (!authProvider.isLoggedIn || authProvider.currentUser == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Route based on user role
   final userRole =  TokenManager.getUserRole();


        debugPrint('🔍 AuthWrapper: Checking user role: $userRole');
    if(userRole == 'driver') {
      return const DriverDashboardScreen();
    } else if (userRole == 'parent') {
      return const ParentDashboardScreen();
    } else {
      return  Scaffold(
        body: Center(child: Text('Unknown role: $userRole')),
      );
    }
        
      },
    );
  }
}
