import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/config/icon_path.dart';
import 'package:flutter/material.dart';

enum RideChildStatus { waiting, onboard, dropped, absent }

class RideChild {
  RideChild({
    required this.name,
    required this.status,
    required this.avatar,
  });

  final String name;
  final String avatar;
  RideChildStatus status;
}

class RideStop {
  RideStop({
    required this.name,
    required this.time,
    required this.children,
  });

  final String name;
  final String time;
  final List<RideChild> children;
}

class DriverRideDetailScreen extends StatefulWidget {
  const DriverRideDetailScreen({super.key});

  @override
  State<DriverRideDetailScreen> createState() => _DriverRideDetailScreenState();
}

class _DriverRideDetailScreenState extends State<DriverRideDetailScreen> {
  final List<RideStop> _stops = [
    RideStop(
      name: 'Stop 1 - Oak Street',
      time: '07:41 am',
      children: [
        RideChild(
          name: 'Katie Doe',
          avatar: IconPath.profileIcon,
          status: RideChildStatus.waiting,
        ),
        RideChild(
          name: 'Sofia Li',
          avatar: IconPath.profileIcon,
          status: RideChildStatus.waiting,
        ),
        RideChild(
          name: 'Nathan Scott',
          avatar: IconPath.profileIcon,
          status: RideChildStatus.waiting,
        ),
      ],
    ),
    RideStop(
      name: 'Stop 2 - Maple Street',
      time: '07:48 am',
      children: [
        RideChild(
          name: 'Leo Harris',
          avatar: IconPath.profileIcon,
          status: RideChildStatus.waiting,
        ),
        RideChild(
          name: 'Alex Smith',
          avatar: IconPath.profileIcon,
          status: RideChildStatus.waiting,
        ),
      ],
    ),
  ];

  String _tab = 'stops';
  RideChildStatus? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding =
        (size.width * 0.045).clamp(16.0, 24.0); // keeps layout responsive
    final totalChildren =
        _stops.fold<int>(0, (sum, stop) => sum + stop.children.length);

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
          'Ride Detail',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: size.height * 0.01 + 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetaRow(size, totalChildren),
            const SizedBox(height: 16),
            _buildHeader(totalChildren),
            const SizedBox(height: 12),
            _buildTabs(),
            const SizedBox(height: 12),
            _buildSearchField(),
            const SizedBox(height: 12),
            _buildFilterChips(),
            const SizedBox(height: 16),
            if (_tab == 'stops') _buildStopsView() else _buildChildrenView(),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(Size size, int totalChildren) {
    final pillHeight = (size.height * 0.06).clamp(48.0, 56.0);
    return Container(
      height: pillHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(pillHeight / 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _metaText('Route A'),
          _dot(),
          _metaText('02:25 pm'),
          _dot(),
          _metaText('$totalChildren Students'),
        ],
      ),
    );
  }

  Widget _buildHeader(int totalChildren) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FA),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Children • $totalChildren',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Grouped by stop, Tap a button to update status',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _tabButton('stops', 'Stops'),
          _tabButton('children', 'Children'),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _query = value.toLowerCase()),
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.4)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = <String, RideChildStatus?>{
      'All': null,
      'Waiting': RideChildStatus.waiting,
      'On board': RideChildStatus.onboard,
      'Dropped': RideChildStatus.dropped,
      'Absent': RideChildStatus.absent,
    };

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: filters.entries.map((entry) {
        final bool isSelected = _filter == entry.value;
        return ChoiceChip(
          label: Text(
            entry.key,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => setState(() => _filter = entry.value),
          backgroundColor: const Color(0xFFF0F0F0),
          selectedColor: Color(0xff96A1DB),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? Color(0xff96A1DB) : Colors.transparent,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStopsView() {
    final filteredStops = _stops
        .map((stop) => RideStop(
              name: stop.name,
              time: stop.time,
              children: stop.children.where(_matchesFilters).toList(),
            ))
        .where((stop) => stop.children.isNotEmpty)
        .toList();

    if (filteredStops.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Text(
          'No children match your filters.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: filteredStops
          .map((stop) => _buildStopCard(stop))
          .toList(growable: false),
    );
  }

  Widget _buildChildrenView() {
    final children = <Map<String, dynamic>>[];
    for (final stop in _stops) {
      for (final child in stop.children) {
        if (_matchesFilters(child)) {
          children.add({'stop': stop.name, 'child': child});
        }
      }
    }

    if (children.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Text(
          'No children match your filters.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: children.map((entry) {
        final RideChild child = entry['child'] as RideChild;
        final String stopName = entry['stop'] as String;
        return _buildChildTile(child, stopName: stopName, showDivider: true);
      }).toList(growable: false),
    );
  }

  Widget _buildStopCard(RideStop stop) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6D8F0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    stop.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  stop.time,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: List.generate(stop.children.length, (index) {
              final child = stop.children[index];
              final bool isLast = index == stop.children.length - 1;
              return _buildChildTile(
                child,
                stopName: stop.name,
                showDivider: !isLast,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChildTile(
    RideChild child, {
    required String stopName,
    bool showDivider = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(showDivider ? 0 : 16),
          bottomRight: Radius.circular(showDivider ? 0 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFECECEC),
                backgroundImage: AssetImage(child.avatar),
                child: child.avatar.isEmpty
                    ? Text(
                        child.name.isNotEmpty ? child.name[0] : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _statusPill(child.status),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            stopName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _actionButton(
                label: 'Onboard',
                color: const Color(0xFF0DB765),
                onTap: () => _updateStatus(child, RideChildStatus.onboard),
              ),
              const SizedBox(width: 8),
              _actionButton(
                label: 'Drop',
                color: const Color(0xFFF9A825),
                onTap: () => _updateStatus(child, RideChildStatus.dropped),
              ),
              const SizedBox(width: 8),
              _actionButton(
                label: 'Absent',
                color: const Color(0xFFE84B4B),
                onTap: () => _updateStatus(child, RideChildStatus.absent),
              ),
            ],
          ),
          if (showDivider) const SizedBox(height: 12),
          if (showDivider)
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusPill(RideChildStatus status) {
    Color bg;
    Color textColor;
    String label;

    switch (status) {
      case RideChildStatus.waiting:
        bg = const Color(0xFFE6D8F0);
        textColor = const Color(0xFF7D5BA6);
        label = 'WAITING';
        break;
      case RideChildStatus.onboard:
        bg = const Color(0xFF0DB765).withOpacity(0.12);
        textColor = const Color(0xFF0DB765);
        label = 'ONBOARD';
        break;
      case RideChildStatus.dropped:
        bg = const Color(0xFFF9A825).withOpacity(0.12);
        textColor = const Color(0xFFF9A825);
        label = 'DROPPED';
        break;
      case RideChildStatus.absent:
        bg = const Color(0xFFE84B4B).withOpacity(0.12);
        textColor = const Color(0xFFE84B4B);
        label = 'ABSENT';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _tabButton(String value, String label) {
    final bool selected = _tab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFD2B7E5) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metaText(String text) {
    return Flexible(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    );
  }

  bool _matchesFilters(RideChild child) {
    final matchesStatus = _filter == null || child.status == _filter;
    final matchesQuery =
        _query.isEmpty || child.name.toLowerCase().contains(_query);
    return matchesStatus && matchesQuery;
  }

  void _updateStatus(RideChild child, RideChildStatus status) {
    setState(() {
      child.status = status;
    });
  }
}
