import 'package:bbpool/views/calendar/driver_calendar_screen.dart';
import 'package:bbpool/views/calendar/parent_calender_screen.dart';
import 'package:bbpool/views/dashboard/driver_dashboard_screen.dart';
import 'package:bbpool/views/dashboard/parent_dashboard_screen.dart';
import 'package:bbpool/views/groups/carpool_groups_screen.dart';
import 'package:bbpool/views/map/map_screen.dart';
import 'package:flutter/material.dart';

class ParentNavBarScreen extends StatefulWidget {
  const ParentNavBarScreen({super.key});

  @override
  State<ParentNavBarScreen> createState() => _ParentNavBarScreenState();
}

class _ParentNavBarScreenState extends State<ParentNavBarScreen> {
  int _selectedIndex = 1; // calendar is selected in your design

  final List<Widget> _pages = const [
    ParentDashboardScreen(),
    ParentCalendarScreen(),
    CarpoolGroupsScreen(),
    MapScreen(),
  ];

  // Colors from the mock
  static const Color _inactive = Color(0xFF969696); // soft grey
  static const Color _active = Color(0xFF8E97FD);   // soft purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFF4F4F4),
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // left side
              Row(
                children: [
                  _buildNavItem(icon: Icons.home_outlined, index: 0),
                  const SizedBox(width: 28),
                  _buildNavItem(icon: Icons.calendar_month_rounded, index: 1),
                ],
              ),
              // right side
              Row(
                children: [
                  _buildNavItem(icon: Icons.group_outlined, index: 2),
                  const SizedBox(width: 28),
                  _buildNavItem(icon: Icons.location_on_outlined, index: 3),
                ],
              ),
            ],
          ),
        ),
      ),

      // Gradient FAB that still creates the notch
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Colors.transparent, // let our gradient show
          onPressed: () {},
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFFECC9F6), // pinkish
                  Color(0xFF9DB2FF), // periwinkle
                ],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  spreadRadius: -2,
                  offset: Offset(0, 6),
                  color: Color(0x33000000),
                ),
              ],
            ),
            alignment: Alignment.topCenter,
            child: const Icon(Icons.add, size: 36, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return InkResponse(
      onTap: () => setState(() => _selectedIndex = index),
      radius: 28,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
            child: Icon(
              icon,
              size: 30,
              color: isSelected ? _active : _inactive,
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
