import 'package:flutter/material.dart';

class MapModel {
  final String driverId;
  final String driverName;
  final String driverImage;
  final String estimatedTime;
  final RideStatus status;
  final List<MapLocation> route;
  final MapLocation currentLocation;
  final MapLocation destination;

  MapModel({
    required this.driverId,
    required this.driverName,
    required this.driverImage,
    required this.estimatedTime,
    required this.status,
    required this.route,
    required this.currentLocation,
    required this.destination,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'] ?? '',
      driverImage: json['driverImage'] ?? '',
      estimatedTime: json['estimatedTime'] ?? '',
      status: RideStatus.values.firstWhere(
        (e) => e.toString() == 'RideStatus.${json['status']}',
        orElse: () => RideStatus.pending,
      ),
      route: (json['route'] as List<dynamic>?)
              ?.map((e) => MapLocation.fromJson(e))
              .toList() ??
          [],
      currentLocation: MapLocation.fromJson(json['currentLocation'] ?? {}),
      destination: MapLocation.fromJson(json['destination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      'driverImage': driverImage,
      'estimatedTime': estimatedTime,
      'status': status.toString().split('.').last,
      'route': route.map((e) => e.toJson()).toList(),
      'currentLocation': currentLocation.toJson(),
      'destination': destination.toJson(),
    };
  }
}

class MapLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? name;

  MapLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
  });

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'name': name,
    };
  }
}

enum RideStatus {
  pending,
  accepted,
  driverArriving,
  inProgress,
  completed,
  cancelled,
}

extension RideStatusExtension on RideStatus {
  String get displayName {
    switch (this) {
      case RideStatus.pending:
        return 'Pending';
      case RideStatus.accepted:
        return 'Accepted';
      case RideStatus.driverArriving:
        return 'Driver Arriving';
      case RideStatus.inProgress:
        return 'In Progress';
      case RideStatus.completed:
        return 'Completed';
      case RideStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case RideStatus.pending:
        return Colors.orange;
      case RideStatus.accepted:
        return Colors.blue;
      case RideStatus.driverArriving:
        return Colors.green;
      case RideStatus.inProgress:
        return Colors.purple;
      case RideStatus.completed:
        return Colors.green;
      case RideStatus.cancelled:
        return Colors.red;
    }
  }
}
