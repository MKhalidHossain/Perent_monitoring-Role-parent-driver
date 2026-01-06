import 'package:bbpool/views/calendar/driver_calendar_screen.dart';
import 'package:bbpool/views/driver/driver_dashboard_screen.dart';
import 'package:bbpool/views/groups/carpool_groups_screen.dart';
import 'package:bbpool/views/map/map_screen.dart';
import 'package:flutter/material.dart';

class DriverNavBarScreen extends StatefulWidget {
  const DriverNavBarScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<DriverNavBarScreen> createState() => _DriverNavBarScreenState();
}

class _DriverNavBarScreenState extends State<DriverNavBarScreen> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    DriverDashboardScreen(),
    DriverCalendarScreen(),
    CarpoolGroupsScreen(),
    MapScreen(),
  ];

  static const Color _inactive = Color(0xFFB0B0B0);
  static const Color _active = Color(0xFF8E97FD);

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom-20;
    final double width = MediaQuery.of(context).size.width;
    final double iconSize = width < 360 ? 24 : 28;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomNavigationBarHeight + bottomInset,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFF4F4F4),
            selectedItemColor: _active,
            unselectedItemColor: _inactive,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: iconSize,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined),
                label: 'Groups',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Location',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
