import 'dart:io';

import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:bbpool/views/profile/profile_setup_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbpool/controllers/settings_controller.dart';
import 'package:bbpool/models/settings_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<SettingsController>(
        builder: (context, settingsController, child) {
          final settings = settingsController.settings;
          final sections = settingsController.getSettingsSections(
            onEmergencyContactTap: () {
              Navigator.pushNamed(context, AppRoutes.emergencyContact);
            },
            onChildHandoffTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.childHandoffVerification,
              );
            },
            onProfileSetupTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentProfileSetupView(),
                ),
              );
            },
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _resolveProfileImage(
                                  settings.profileImage,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editProfile,
                                );
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9C88FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                       "${settings.name}1",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        settings.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Sections
                ...sections.map((section) =>
                    _buildSettingsSection(section, settingsController)),
                const SizedBox(height: 100),

                // Action Buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Logout Button
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _showLogoutDialog(context, authProvider);
                              },
                              borderRadius: BorderRadius.circular(25),
                              child: const Center(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Delete Account Button
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFFF6B6B)),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _showDeleteAccountDialog(
                                    context, settingsController);
                              },
                              borderRadius: BorderRadius.circular(25),
                              child: const Center(
                                child: Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    color: Color(0xFFFF6B6B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          );
        },
      ),
    );
  }

  ImageProvider _resolveProfileImage(String imagePath) {
    if (imagePath.isEmpty) {
      return const AssetImage(IconPath.profileIcon);
    }
    final uri = Uri.tryParse(imagePath);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return NetworkImage(imagePath);
    }
    return FileImage(File(imagePath));
  }

  Widget _buildSettingsSection(
      SettingsSection section, SettingsController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              section.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          ...section.items.map((item) => _buildSettingsItem(item, controller)),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(SettingsItem item, SettingsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              if (item.hasToggle) ...[
                Switch(
                  value: item.toggleValue,
                  onChanged: (value) {
                    if (item.title == 'Dark Mode') {
                      controller.toggleDarkMode();
                    } else if (item.title == 'Notification Settings') {
                      controller.toggleNotifications();
                    }
                  },
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                ),
              ] else if (item.hasArrow) ...[
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                authProvider.logout(context);
                // Handle logout
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteAccount();
                // Handle account deletion
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          ],
        );
      },
    );
  }
}
