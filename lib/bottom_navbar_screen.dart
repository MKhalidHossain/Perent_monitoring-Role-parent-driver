import 'package:bbpool/views/calendar/driver_calendar_screen.dart';
import 'package:bbpool/views/dashboard/driver_dashboard_screen.dart';
import 'package:bbpool/views/groups/carpool_groups_screen.dart';
import 'package:bbpool/views/map/map_screen.dart';
import 'package:bbpool/views/messages/chat_screen.dart';
import 'package:bbpool/widgets/common_widgets.dart';
import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/controllers/message_controller.dart';
import 'package:bbpool/controllers/notification_controller.dart';
import 'package:bbpool/controllers/settings_controller.dart';
import 'package:bbpool/models/message_model.dart';
import 'package:bbpool/models/notification_model.dart';
import 'package:bbpool/models/settings_model.dart';
import 'package:bbpool/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum OverlayScreen { none, profile, messages, notifications, settings }

class DriverNavBarScreen extends StatefulWidget {
  const DriverNavBarScreen({super.key});

  @override
  State<DriverNavBarScreen> createState() => _DriverNavBarScreenState();
}

class _DriverNavBarScreenState extends State<DriverNavBarScreen> {
  int _selectedIndex = 1; // calendar is selected in your design
  OverlayScreen _overlayScreen = OverlayScreen.none;

  final List<Widget> _pages = const [
    DriverDashboardScreen(),
    DriverCalendarScreen(),
    CarpoolGroupsScreen(),
    MapScreen(),
  ];

  // Colors from the mock
  static const Color _inactive = Color(0xFF969696); // soft grey
  static const Color _active = Color(0xFF8E97FD); // soft purple

  void _showOverlayScreen(OverlayScreen screen) {
    setState(() {
      _overlayScreen = screen;
    });
  }

  void _hideOverlayScreen() {
    setState(() {
      _overlayScreen = OverlayScreen.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: CommonWidgets.buildHeaderSection(
              context: context,
              profileImagePath: IconPath.profileIcon,
              chatIconPath: IconPath.chatIcon,
              notificationIconPath: IconPath.notificationIcon,
              settingsIconPath: IconPath.settingsIcon,
              onProfileTap: () => _showOverlayScreen(OverlayScreen.profile),
              onChatPressed: () => _showOverlayScreen(OverlayScreen.messages),
              onNotificationPressed: () =>
                  _showOverlayScreen(OverlayScreen.notifications),
              onSettingsPressed: () =>
                  _showOverlayScreen(OverlayScreen.settings),
            ),
          ),
        ),
      ),
      body: _overlayScreen != OverlayScreen.none
          ? _buildOverlayScreen()
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFF4F4F4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(icon: Icons.home_outlined, index: 0),
            _buildNavItem(icon: Icons.calendar_month_rounded, index: 1),
            _buildNavItem(icon: Icons.group_outlined, index: 2),
            _buildNavItem(icon: Icons.location_on_outlined, index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayScreen() {
    switch (_overlayScreen) {
      case OverlayScreen.profile:
        return _ProfileScreenContent(onBack: _hideOverlayScreen);
      case OverlayScreen.messages:
        return _MessageListScreenContent(onBack: _hideOverlayScreen);
      case OverlayScreen.notifications:
        return _NotificationScreenContent(onBack: _hideOverlayScreen);
      case OverlayScreen.settings:
        return _SettingsScreenContent(onBack: _hideOverlayScreen);
      case OverlayScreen.none:
        return _pages[_selectedIndex];
    }
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return InkResponse(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _overlayScreen = OverlayScreen.none; // Hide overlay when switching tabs
        });
      },
      radius: 28,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            child: Icon(
              icon,
              size: 30,
              color: isSelected ? _active : _inactive,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

// Wrapper widgets that extract body content from screens
class _ProfileScreenContent extends StatelessWidget {
  final VoidCallback onBack;

  const _ProfileScreenContent({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding =
        (size.width * 0.06).clamp(16.0, 24.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          size.height * 0.015 + 8,
          horizontalPadding,
          size.height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: onBack,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Driver Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            _buildProfileHeader(),
            SizedBox(height: size.height * 0.02),
            _buildInboxButton(),
            SizedBox(height: size.height * 0.03),
            const Text(
              'Driver Stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 14),
            _buildStatsGrid(size),
            SizedBox(height: size.height * 0.03),
            const Text(
              'Rating & Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildRatingSummary(),
            const SizedBox(height: 18),
            ..._reviews
                .map((review) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: _buildReviewCard(review),
                    )),
            const SizedBox(height: 12),
            _buildReadMoreButton(),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage(IconPath.profileIcon),
          ),
          const SizedBox(height: 12),
          const Text(
            'Driver Sam',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                '4.97 - 223 Ratings',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInboxButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD99BD9), Color(0xFF8E9AEF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Inbox me',
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
    );
  }

  Widget _buildStatsGrid(Size size) {
    final stats = [
      _Stat('Rides Completed', '53 Rides', Icons.directions_bus_filled),
      _Stat('On-Time Pickups', '94%', Icons.alarm_on),
      _Stat('Cancellations', '13', Icons.cancel_outlined),
      _Stat('Children Dropped', '02', Icons.family_restroom),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatCard(stat);
      },
    );
  }

  Widget _buildStatCard(_Stat stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                stat.icon,
                size: 22,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stat.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '4.97',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const Text(
                '200 Reviews',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 3,
          child: Column(
            children: [
              _RatingBar(stars: 5, percent: 0.8),
              _RatingBar(stars: 4, percent: 0.7),
              _RatingBar(stars: 3, percent: 0.55),
              _RatingBar(stars: 2, percent: 0.2),
              _RatingBar(stars: 1, percent: 0.1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(_Review review) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(review.avatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              review.timeAgo,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            review.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.review,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(height: 1, color: Colors.grey.withOpacity(0.15)),
      ],
    );
  }

  Widget _buildReadMoreButton() {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF8B92E3),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Read More',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageListScreenContent extends StatefulWidget {
  final VoidCallback onBack;

  const _MessageListScreenContent({required this.onBack});

  @override
  State<_MessageListScreenContent> createState() =>
      _MessageListScreenContentState();
}

class _MessageListScreenContentState
    extends State<_MessageListScreenContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MessageController>().initializeMessages();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with back button

     
     
       // Search Bar
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              context.read<MessageController>().setSearchQuery(value);
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        // Messages List
        Expanded(
          child: Consumer<MessageController>(
            builder: (context, messageController, child) {
              if (messageController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF9C88FF),
                  ),
                );
              }

              final messages = messageController.filteredMessages;

              if (messages.isEmpty) {
                return const Center(
                  child: Text(
                    'No messages found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageTile(context, message);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 80), // Space for bottom nav
      ],
    );
  }

  Widget _buildMessageTile(BuildContext context, MessageModel message) {
    return InkWell(
      onTap: () {
        context.read<MessageController>().markAsRead(message.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userId: message.senderId,
              userName: message.senderName,
              userAvatar: message.senderAvatar,
              isOnline: message.isOnline,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(message.senderAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (message.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.senderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: message.unreadCount > 0
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: message.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (message.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF9C88FF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              message.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _NotificationScreenContent extends StatefulWidget {
  final VoidCallback onBack;

  const _NotificationScreenContent({required this.onBack});

  @override
  State<_NotificationScreenContent> createState() =>
      _NotificationScreenContentState();
}

class _NotificationScreenContentState
    extends State<_NotificationScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationController>().initializeNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with back button
  
       
       
        // Notifications List
        Expanded(
          child: Consumer<NotificationController>(
            builder: (context, notificationController, child) {
              if (notificationController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF9C88FF),
                  ),
                );
              }

              final notifications = notificationController.notifications;

              if (notifications.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'You\'ll see notifications here when you get them',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationTile(
                      context, notification, notificationController);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 80), // Space for bottom nav
      ],
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    NotificationModel notification,
    NotificationController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.type.iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.type.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        controller.formatTimeAgo(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (notification.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        notification.subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    notification.data?['date'] ?? 'Saturday, August 22, 2025',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFF9C88FF),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsScreenContent extends StatelessWidget {
  final VoidCallback onBack;

  const _SettingsScreenContent({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
  
     
     
        Expanded(
          child: Consumer<SettingsController>(
            builder: (context, settingsController, child) {
              final settings = settingsController.settings;
              final sections = settingsController.getSettingsSections();

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
                                    image: NetworkImage(settings.profileImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF9C88FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            settings.name,
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
                    const SizedBox(height: 20),
                    // Action Buttons
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
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
                    const SizedBox(height: 100),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 80), // Space for bottom nav
      ],
    );
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

// Helper classes for profile screen
class _Stat {
  _Stat(this.title, this.value, this.icon);
  final String title;
  final String value;
  final IconData icon;
}

class _Review {
  _Review({
    required this.name,
    required this.timeAgo,
    required this.rating,
    required this.review,
    required this.avatar,
  });

  final String name;
  final String timeAgo;
  final double rating;
  final String review;
  final String avatar;
}

List<_Review> _reviews = [
  _Review(
    name: 'Antwon Taylor',
    timeAgo: '1 month ago',
    rating: 4.0,
    review:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet gravida nulla.',
    avatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=faces',
  ),
  _Review(
    name: 'Jamie Scott',
    timeAgo: '2 months ago',
    rating: 5.0,
    review:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet gravida nulla.',
    avatar:
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=faces',
  ),
  _Review(
    name: 'Nathan Scott',
    timeAgo: '3 months ago',
    rating: 3.0,
    review:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet gravida nulla.',
    avatar:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=faces',
  ),
];

class _RatingBar extends StatelessWidget {
  const _RatingBar({required this.stars, required this.percent});

  final int stars;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E9AEF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percent * 100).round()}%',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
