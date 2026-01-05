import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bbpool/widgets/common_widgets.dart';

class DriverPreTripChecklistScreen extends StatefulWidget {
  const DriverPreTripChecklistScreen({super.key});

  @override
  State<DriverPreTripChecklistScreen> createState() =>
      _DriverPreTripChecklistScreenState();
}

class _DriverPreTripChecklistScreenState
    extends State<DriverPreTripChecklistScreen> {
  final List<_ChecklistItem> _items = [
    _ChecklistItem(
      title: 'Vehicle condition checked (brakes, lights, mirrors)',
      checked: true,
    ),
    _ChecklistItem(title: 'Fuel level sufficient', checked: true),
    _ChecklistItem(title: 'Seatbelts in working order', checked: true),
    _ChecklistItem(title: 'Emergency contact list available'),
    _ChecklistItem(title: 'First aid kit onboard'),
    _ChecklistItem(
      title: 'Cleanliness check (inside bus)',
      checked: true,
    ),
    _ChecklistItem(title: 'GPS device or app running'),
    _ChecklistItem(title: 'Driver ID visible or worn'),
    _ChecklistItem(
      title: 'Assigned route reviewed',
      checked: true,
    ),
    _ChecklistItem(
      title: 'Attendance sheet (physical or in-app) ready',
      checked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding =
        (size.width * 0.05).clamp(16.0, 24.0); // responsive gutters

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            size.height * 0.015 + 8,
            horizontalPadding,
            size.height * 0.04,
          ),
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
              const SizedBox(height: 12),
              const Text(
                'Daily Pre-Trip Checklist',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Complete this before starting today’s school run.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              ..._items.map((item) => _buildChecklistTile(item)),
              SizedBox(height: size.height * 0.06),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistTile(_ChecklistItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => item.checked = !item.checked),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.checked ? const Color(0xFF8A8CE3) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      item.checked ? Colors.transparent : Colors.grey.shade400,
                  width: 1.4,
                ),
                boxShadow: item.checked
                    ? [
                        BoxShadow(
                          color: const Color(0xFF8A8CE3).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: item.checked
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => item.checked = !item.checked),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradientButton,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final allChecked = _items.every((item) => item.checked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          allChecked
              ? 'Checklist completed! Have a safe trip.'
              : 'Please complete all items before starting.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ChecklistItem {
  _ChecklistItem({
    required this.title,
    this.checked = false,
  });

  final String title;
  bool checked;
}
