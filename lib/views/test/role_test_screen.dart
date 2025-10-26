import 'package:flutter/material.dart';
import 'package:bbpool/utils/role_navigation_helper.dart';
import 'package:bbpool/routes/app_routes.dart';

class RoleTestScreen extends StatelessWidget {
  const RoleTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Navigation Test'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test Role-Based Navigation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Driver Role Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(RoleNavigationHelper.getRoleIcon('driver'), 
                             size: 32, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text(
                          RoleNavigationHelper.getRoleDisplayName('driver'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Test navigation to Driver Dashboard'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        RoleNavigationHelper.navigateToDashboard(context, 'driver');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Navigate as Driver'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Parent Role Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(RoleNavigationHelper.getRoleIcon('parent'), 
                             size: 32, color: Colors.green),
                        const SizedBox(width: 12),
                        Text(
                          RoleNavigationHelper.getRoleDisplayName('parent'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Test navigation to Parent Dashboard'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        RoleNavigationHelper.navigateToDashboard(context, 'parent');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Navigate as Parent'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Invalid Role Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(RoleNavigationHelper.getRoleIcon('admin'), 
                             size: 32, color: Colors.red),
                        const SizedBox(width: 12),
                        Text(
                          RoleNavigationHelper.getRoleDisplayName('admin'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Test navigation with invalid role'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        RoleNavigationHelper.navigateToDashboard(context, 'admin');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Navigate as Admin (Invalid)'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Back to Login
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
