import 'package:flutter/foundation.dart';
import 'package:bbpool/models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Initialize with sample data matching the design
  void initializeNotifications() {
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Your child\'s ride has started.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.rideStarted,
        isRead: false,
        data: {'date': 'Saturday, August 22, 2025'},
      ),
      NotificationModel(
        id: '2',
        title: 'You\'ve received a new message',
        subtitle: 'Hey Did you see the bus anywhere?',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: NotificationType.newMessage,
        isRead: false,
        data: {'date': 'Saturday, August 22, 2025'},
      ),
      NotificationModel(
        id: '3',
        title: 'Bus has arrived at pickup point',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: NotificationType.busArrived,
        isRead: false,
        data: {'date': 'Saturday, August 22, 2025'},
      ),
      NotificationModel(
        id: '4',
        title: 'ETA updated: 7:45 AM → 7:55 AM',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: NotificationType.etaUpdate,
        isRead: false,
        data: {'date': 'Saturday, August 22, 2025'},
      ),
      NotificationModel(
        id: '5',
        title: 'Ride was canceled by the driver',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
        type: NotificationType.rideCanceled,
        isRead: false,
        data: {'date': 'Saturday, August 22, 2025'},
      ),
    ];
    notifyListeners();
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  // Add new notification
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // Remove notification
  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Get notifications by type
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Get unread notifications
  List<NotificationModel> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  String formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 day ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
