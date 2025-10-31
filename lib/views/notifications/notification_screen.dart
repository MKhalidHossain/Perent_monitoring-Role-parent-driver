import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbpool/controllers/notification_controller.dart';
import 'package:bbpool/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationController>().initializeNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          Consumer<NotificationController>(
            builder: (context, notificationController, child) {
              if (notificationController.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    notificationController.markAllAsRead();
                  },
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(
                      color: Color(0xFF9C88FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<NotificationController>(
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
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB39DDB), Color(0xFF9C88FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Handle add action
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home_outlined, false),
            _buildBottomNavItem(Icons.calendar_today_outlined, false),
            const SizedBox(width: 56), // Space for FAB
            _buildBottomNavItem(Icons.people_outline, false),
            _buildBottomNavItem(Icons.location_on_outlined, false),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          // Handle notification tap action
          _handleNotificationTap(notification);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
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

            // Content
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

                  // Subtitle if exists
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

                  // Date
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

            // Unread indicator
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

  Widget _buildBottomNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Icon(
        icon,
        size: 24,
        color: isActive ? const Color(0xFF9C88FF) : Colors.grey,
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.newMessage:
        // Navigate to messages
        // Navigator.pushNamed(context, AppRoutes.messageList);
        break;
      case NotificationType.rideStarted:
      case NotificationType.busArrived:
      case NotificationType.etaUpdate:
        // Navigate to ride tracking
        break;
      case NotificationType.rideCanceled:
        // Show ride canceled details
        break;
      case NotificationType.general:
        // Handle general notification
        break;
    }
  }
}
