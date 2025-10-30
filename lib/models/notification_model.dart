import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.general,
      ),
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'data': data,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }
}

enum NotificationType {
  rideStarted,
  newMessage,
  busArrived,
  etaUpdate,
  rideCanceled,
  general,
}

extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.rideStarted:
        return Icons.check_circle;
      case NotificationType.newMessage:
        return Icons.message;
      case NotificationType.busArrived:
        return Icons.directions_bus;
      case NotificationType.etaUpdate:
        return Icons.schedule;
      case NotificationType.rideCanceled:
        return Icons.cancel;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color get iconColor {
    switch (this) {
      case NotificationType.rideStarted:
        return Colors.green;
      case NotificationType.newMessage:
        return Colors.blue;
      case NotificationType.busArrived:
        return Colors.teal;
      case NotificationType.etaUpdate:
        return Colors.orange;
      case NotificationType.rideCanceled:
        return Colors.red;
      case NotificationType.general:
        return Colors.grey;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NotificationType.rideStarted:
        return Colors.green.withValues(alpha: 0.1);
      case NotificationType.newMessage:
        return Colors.blue.withValues(alpha: 0.1);
      case NotificationType.busArrived:
        return Colors.teal.withValues(alpha: 0.1);
      case NotificationType.etaUpdate:
        return Colors.orange.withValues(alpha: 0.1);
      case NotificationType.rideCanceled:
        return Colors.red.withValues(alpha: 0.1);
      case NotificationType.general:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }
}
