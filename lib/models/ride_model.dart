class RideModel {
  final String id;
  final String departureTime;
  final String arrivalTime;
  final String assignedDriver;
  final RideStatus status;
  final RideType type;

  RideModel({
    required this.id,
    required this.departureTime,
    required this.arrivalTime,
    required this.assignedDriver,
    required this.status,
    required this.type,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      assignedDriver: json['assignedDriver'] ?? '',
      status: RideStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => RideStatus.pending,
      ),
      type: RideType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => RideType.departure,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'assignedDriver': assignedDriver,
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
    };
  }
}

enum RideStatus {
  completed,
  pending,
  cancelled,
  inProgress,
}

enum RideType {
  departure,
  arrival,
}

class MonthlyStatsModel {
  final int ridesCompleted;
  final int onTimePickups;
  final int scheduledRides;
  final int activeCarpoolGroups;

  MonthlyStatsModel({
    required this.ridesCompleted,
    required this.onTimePickups,
    required this.scheduledRides,
    required this.activeCarpoolGroups,
  });

  factory MonthlyStatsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyStatsModel(
      ridesCompleted: json['ridesCompleted'] ?? 0,
      onTimePickups: json['onTimePickups'] ?? 0,
      scheduledRides: json['scheduledRides'] ?? 0,
      activeCarpoolGroups: json['activeCarpoolGroups'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ridesCompleted': ridesCompleted,
      'onTimePickups': onTimePickups,
      'scheduledRides': scheduledRides,
      'activeCarpoolGroups': activeCarpoolGroups,
    };
  }

  String get onTimePercentage {
    if (ridesCompleted == 0) return '0%';
    return '${((onTimePickups / ridesCompleted) * 100).round()}%';
  }
}
