class RideModel {
  final String id;
  final String departureTime;
  final String arrivalTime;
  final int ridersCount;
  final String driverName;
  final String status;
  final String vehicleType;

  RideModel({
    required this.id,
    required this.departureTime,
    required this.arrivalTime,
    required this.ridersCount,
    required this.driverName,
    required this.status,
    required this.vehicleType,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      ridersCount: json['ridersCount'] ?? 0,
      driverName: json['driverName'] ?? '',
      status: json['status'] ?? 'pending',
      vehicleType: json['vehicleType'] ?? 'van',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'ridersCount': ridersCount,
      'driverName': driverName,
      'status': status,
      'vehicleType': vehicleType,
    };
  }
}

class StatModel {
  final String title;
  final String value;
  final String icon;
  final String color;

  StatModel({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  factory StatModel.fromJson(Map<String, dynamic> json) {
    return StatModel(
      title: json['title'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#FF6B6B',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'icon': icon,
      'color': color,
    };
  }
}

class DashboardModel {
  final List<RideModel> todayRides;
  final List<StatModel> monthlyStats;
  final int credits;
  final String userName;
  final String userRole;

  DashboardModel({
    required this.todayRides,
    required this.monthlyStats,
    required this.credits,
    required this.userName,
    required this.userRole,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      todayRides: (json['todayRides'] as List?)
          ?.map((ride) => RideModel.fromJson(ride))
          .toList() ?? [],
      monthlyStats: (json['monthlyStats'] as List?)
          ?.map((stat) => StatModel.fromJson(stat))
          .toList() ?? [],
      credits: json['credits'] ?? 0,
      userName: json['userName'] ?? '',
      userRole: json['userRole'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayRides': todayRides.map((ride) => ride.toJson()).toList(),
      'monthlyStats': monthlyStats.map((stat) => stat.toJson()).toList(),
      'credits': credits,
      'userName': userName,
      'userRole': userRole,
    };
  }
}
