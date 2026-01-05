import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:flutter/material.dart';

class ScheduleChildRideScreen extends StatefulWidget {
  const ScheduleChildRideScreen({super.key});

  @override
  State<ScheduleChildRideScreen> createState() =>
      _ScheduleChildRideScreenState();
}

class _ScheduleChildRideScreenState extends State<ScheduleChildRideScreen> {
  static const LinearGradient _lavenderGradient = AppColors.gradientButton;
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> _childProfiles = ['Katie Doe', 'Mason Doe', 'Luna Doe'];
  final List<String> _rideTypes = ['Home to School', 'School to Home'];
  final List<String> _paymentOptions = ['Ride Credits', 'Card'];
  final List<String> _dropoffOptions = [
    'North London Collegiate School - Edgware',
    'St. Mary Primary School',
  ];

  final List<DateTime> _selectedDateTimes = [
    DateTime(2025, 8, 1, 7, 30),
    DateTime(2025, 8, 5, 7, 30),
    DateTime(2025, 8, 8, 7, 30),
    DateTime(2025, 8, 9, 7, 30),
    DateTime(2025, 8, 12, 7, 30),
    DateTime(2025, 8, 15, 7, 30),
  ];

  String _selectedChild = 'Katie Doe';
  String _selectedRideType = 'Home to School';
  String _selectedPaymentOption = 'Ride Credits';
  String _selectedDropoff = 'North London Collegiate School - Edgware';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding =
        (size.width * 0.06).clamp(18.0, 24.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Schedule your child's ride",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Selected Date & time'),
              _buildDateChips(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildGradientButton(
                      label: 'Add Date & Time',
                      onTap: _openDateTimeSheet,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildOutlineButton(
                      label: 'Clear All',
                      onTap: () => setState(_selectedDateTimes.clear),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _buildSectionTitle('Select Child Profile'),
              _buildDropdownCard(
                leading: const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(IconPath.profileIcon),
                ),
                value: _selectedChild,
                items: _childProfiles,
                onChanged: (value) => setState(() => _selectedChild = value),
              ),
              const SizedBox(height: 22),
              _buildSectionTitle('Ride Type'),
              _buildDropdownCard(
                value: _selectedRideType,
                items: _rideTypes,
                onChanged: (value) => setState(() => _selectedRideType = value),
              ),
              const SizedBox(height: 22),
              _buildSectionTitle('Pickup Location'),
              _buildLocationCard(
                rows: const [
                  _LocationRow(label: 'Street Address', value: '27 Baker Street'),
                  _LocationRow(label: 'Area', value: 'Kensington'),
                  _LocationRow(label: 'Postcode', value: 'NW1 6XE'),
                ],
              ),
              const SizedBox(height: 22),
              _buildSectionTitle('Drop-off Location'),
              _buildDropdownCard(
                value: _selectedDropoff,
                items: _dropoffOptions,
                onChanged: (value) => setState(() => _selectedDropoff = value),
              ),
              const SizedBox(height: 18),
              const Divider(height: 24),
              _buildPaymentRow(
                label: 'Total Payment',
                value: '\$17.82',
                valueColor: const Color(0xFF1DB954),
              ),
              const SizedBox(height: 6),
              _buildPaymentRow(
                label: 'Payment in Ride Credits',
                value: '10 Credits',
                valueColor: const Color(0xFFFF9E2C),
              ),
              const SizedBox(height: 18),
              _buildSectionTitle('Payment Option'),
              _buildDropdownCard(
                value: _selectedPaymentOption,
                items: _paymentOptions,
                onChanged: (value) =>
                    setState(() => _selectedPaymentOption = value),
              ),
              const SizedBox(height: 18),
              const Divider(height: 24),
              _buildPaymentRow(
                label: 'Available Credits',
                value: '70 Credits',
                valueColor: const Color(0xFFFF9E2C),
              ),
              const SizedBox(height: 26),
              _buildGradientButton(
                label: 'Request Ride',
                onTap: () {},
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDateChips() {
    if (_selectedDateTimes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          'No dates added yet.',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _selectedDateTimes.map(_buildDateChip).toList(),
    );
  }

  Widget _buildDateChip(DateTime dateTime) {
    final String month = _monthNames[dateTime.month - 1].substring(0, 3);
    final String timeLabel = _formatTime(dateTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              text: '$month ${dateTime.day} ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: timeLabel,
                  style: const TextStyle(
                    color: Color(0xFFB36CB8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _selectedDateTimes.remove(dateTime)),
            child: const Icon(Icons.close, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required VoidCallback onTap,
    double height = 50,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: _lavenderGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB89DD8).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.gradientButtonEnd),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.gradientButtonEnd,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownCard({
    Widget? leading,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (leading != null) leading,
          if (leading != null) const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard({required List<_LocationRow> rows}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: rows
            .map(
              (row) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    row.value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (row != rows.last)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1),
                    ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPaymentRow({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour % 12;
    if (hour == 0) {
      hour = 12;
    }
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _openDateTimeSheet() async {
    final DateTime initial =
        _selectedDateTimes.isNotEmpty ? _selectedDateTimes.last : DateTime.now();
    DateTime selectedDate =
        DateTime(initial.year, initial.month, initial.day);
    int displayMonth = selectedDate.month;
    int displayYear = selectedDate.year;
    int selectedHour = initial.hour % 12 == 0 ? 12 : initial.hour % 12;
    int selectedMinute = initial.minute;
    bool isAm = initial.hour < 12;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final String monthLabel =
                '${_monthNames[displayMonth - 1]} $displayYear'
                    .toUpperCase();
            return SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select a Date & time',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.close, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9FD),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8E8F0)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                monthLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  _buildMonthArrow(
                                    icon: Icons.chevron_left,
                                    onTap: () {
                                      setModalState(() {
                                        if (displayMonth == 1) {
                                          displayMonth = 12;
                                          displayYear -= 1;
                                        } else {
                                          displayMonth -= 1;
                                        }
                                        selectedDate = _clampDate(
                                          selectedDate,
                                          displayYear,
                                          displayMonth,
                                        );
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  _buildMonthArrow(
                                    icon: Icons.chevron_right,
                                    onTap: () {
                                      setModalState(() {
                                        if (displayMonth == 12) {
                                          displayMonth = 1;
                                          displayYear += 1;
                                        } else {
                                          displayMonth += 1;
                                        }
                                        selectedDate = _clampDate(
                                          selectedDate,
                                          displayYear,
                                          displayMonth,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildWeekdayHeader(),
                          const SizedBox(height: 8),
                          _buildCalendarGrid(
                            displayYear: displayYear,
                            displayMonth: displayMonth,
                            selectedDate: selectedDate,
                            onSelect: (date) {
                              setModalState(() => selectedDate = date);
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimeDropdown(
                                value: selectedHour,
                                items: List.generate(12, (index) => index + 1),
                                onChanged: (value) {
                                  setModalState(() => selectedHour = value);
                                },
                                active: true,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                ':',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildTimeDropdown(
                                value: selectedMinute,
                                items: List.generate(60, (index) => index),
                                onChanged: (value) {
                                  setModalState(() => selectedMinute = value);
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAmPmToggle(
                                isAm: isAm,
                                onChanged: (value) {
                                  setModalState(() => isAm = value);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildGradientButton(
                      label: 'Add',
                      onTap: () {
                        final int hour =
                            isAm ? selectedHour % 12 : (selectedHour % 12) + 12;
                        final DateTime newDate = DateTime(
                          displayYear,
                          displayMonth,
                          selectedDate.day,
                          hour,
                          selectedMinute,
                        );
                        if (!_selectedDateTimes.any(
                          (existing) => existing.isAtSameMomentAs(newDate),
                        )) {
                          setState(() => _selectedDateTimes.add(newDate));
                        }
                        Navigator.pop(context);
                      },
                      height: 54,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  DateTime _clampDate(DateTime date, int year, int month) {
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int safeDay =
        date.day.clamp(1, daysInMonth).toInt();
    return DateTime(year, month, safeDay);
  }

  Widget _buildWeekdayHeader() {
    const List<String> weekdays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekdays
          .map(
            (day) => Expanded(
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid({
    required int displayYear,
    required int displayMonth,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onSelect,
  }) {
    final DateTime firstDay = DateTime(displayYear, displayMonth, 1);
    final int daysInMonth = DateUtils.getDaysInMonth(displayYear, displayMonth);
    final int startOffset = (firstDay.weekday + 6) % 7;
    final List<Widget> dayTiles = List.generate(startOffset, (_) {
      return const SizedBox.shrink();
    });

    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime dayDate = DateTime(displayYear, displayMonth, day);
      final bool isSelected = selectedDate.year == displayYear &&
          selectedDate.month == displayMonth &&
          selectedDate.day == day;
      final bool isMarked = _selectedDateTimes.any((date) =>
          date.year == displayYear &&
          date.month == displayMonth &&
          date.day == day);

      dayTiles.add(
        GestureDetector(
          onTap: () => onSelect(dayDate),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFFD7BDEB)
                      : const Color(0xFFF1F2F8),
                ),
                alignment: Alignment.center,
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isMarked)
                Positioned(
                  top: 6,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF9DB2FF),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      crossAxisSpacing: 6,
      mainAxisSpacing: 10,
      children: dayTiles,
    );
  }

  Widget _buildMonthArrow({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildTimeDropdown({
    required int value,
    required List<int> items,
    required ValueChanged<int> onChanged,
    bool active = false,
  }) {
    return Container(
      width: 72,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEAD1EF) : const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          icon: const SizedBox.shrink(),
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Center(
                    child: Text(item.toString().padLeft(2, '0')),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAmPmToggle({
    required bool isAm,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: 54,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                decoration: BoxDecoration(
                  color: isAm ? const Color(0xFFEAD1EF) : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'AM',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isAm ? const Color(0xFFEAD1EF) : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'PM',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationRow {
  const _LocationRow({required this.label, required this.value});

  final String label;
  final String value;
}
