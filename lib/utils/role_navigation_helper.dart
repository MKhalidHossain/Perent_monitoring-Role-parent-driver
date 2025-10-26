import 'package:flutter/material.dart';
import 'package:bbpool/routes/app_routes.dart';

class RoleNavigationHelper {
  /// Navigate to appropriate dashboard based on user role
  static void navigateToDashboard(BuildContext context, String role) {
    final userRole = role.toLowerCase();
    debugPrint('🔍 RoleNavigationHelper: Checking user role: $userRole');
    
    switch (userRole) {
      case 'driver':
        debugPrint('🚗 RoleNavigationHelper: Navigating to Driver Dashboard');
        Navigator.of(context).pushReplacementNamed(AppRoutes.driverDashboard);
        break;
      case 'parent':
        debugPrint('👨‍👩‍👧‍👦 RoleNavigationHelper: Navigating to Parent Dashboard');
        Navigator.of(context).pushReplacementNamed(AppRoutes.parentDashboard);
        break;
      default:
        debugPrint('❌ RoleNavigationHelper: Unknown role: $userRole, navigating to AuthWrapper');
        Navigator.of(context).pushReplacementNamed(AppRoutes.authWrapper);
        break;
    }
  }
  
  /// Check if user role is valid
  static bool isValidRole(String role) {
    final validRoles = ['driver', 'parent'];
    return validRoles.contains(role.toLowerCase());
  }
  
  /// Get display name for role
  static String getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'driver':
        return 'Driver';
      case 'parent':
        return 'Parent';
      default:
        return 'Unknown';
    }
  }
  
  /// Get role-specific icon
  static IconData getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'driver':
        return Icons.directions_car;
      case 'parent':
        return Icons.family_restroom;
      default:
        return Icons.person;
    }
  }
}
