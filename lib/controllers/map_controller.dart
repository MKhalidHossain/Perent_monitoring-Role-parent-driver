import 'package:flutter/foundation.dart';
import 'package:bbpool/models/map_model.dart';

class MapController extends ChangeNotifier {
  MapModel? _currentRide;
  bool _isLoading = false;
  String? _errorMessage;

  MapModel? get currentRide => _currentRide;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Initialize with sample ride data matching the design
  void initializeRide() {
    _currentRide = MapModel(
      driverId: 'sam_smith',
      driverName: 'Sam Smith',
      driverImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      estimatedTime: '5 min away',
      status: RideStatus.driverArriving,
      route: [
        MapLocation(
          latitude: -37.8136,
          longitude: 144.9631,
          name: 'Start Point',
        ),
        MapLocation(
          latitude: -37.8200,
          longitude: 144.9700,
          name: 'Waypoint 1',
        ),
        MapLocation(
          latitude: -37.8250,
          longitude: 144.9750,
          name: 'Destination',
        ),
      ],
      currentLocation: MapLocation(
        latitude: -37.8136,
        longitude: 144.9631,
        address: 'Melbourne, VIC, Australia',
        name: 'Current Location',
      ),
      destination: MapLocation(
        latitude: -37.8250,
        longitude: 144.9750,
        address: 'Destination Address',
        name: 'Destination',
      ),
    );
    notifyListeners();
  }

  // Update driver location (simulate real-time tracking)
  void updateDriverLocation(double latitude, double longitude) {
    if (_currentRide != null) {
      _currentRide = MapModel(
        driverId: _currentRide!.driverId,
        driverName: _currentRide!.driverName,
        driverImage: _currentRide!.driverImage,
        estimatedTime: _currentRide!.estimatedTime,
        status: _currentRide!.status,
        route: _currentRide!.route,
        currentLocation: MapLocation(
          latitude: latitude,
          longitude: longitude,
          address: _currentRide!.currentLocation.address,
          name: _currentRide!.currentLocation.name,
        ),
        destination: _currentRide!.destination,
      );
      notifyListeners();
    }
  }

  // Cancel ride
  void cancelRide() {
    if (_currentRide != null) {
      _currentRide = MapModel(
        driverId: _currentRide!.driverId,
        driverName: _currentRide!.driverName,
        driverImage: _currentRide!.driverImage,
        estimatedTime: _currentRide!.estimatedTime,
        status: RideStatus.cancelled,
        route: _currentRide!.route,
        currentLocation: _currentRide!.currentLocation,
        destination: _currentRide!.destination,
      );
      notifyListeners();
    }
  }

  // Update ride status
  void updateRideStatus(RideStatus status) {
    if (_currentRide != null) {
      _currentRide = MapModel(
        driverId: _currentRide!.driverId,
        driverName: _currentRide!.driverName,
        driverImage: _currentRide!.driverImage,
        estimatedTime: _currentRide!.estimatedTime,
        status: status,
        route: _currentRide!.route,
        currentLocation: _currentRide!.currentLocation,
        destination: _currentRide!.destination,
      );
      notifyListeners();
    }
  }

  // Clear current ride
  void clearRide() {
    _currentRide = null;
    _errorMessage = null;
    notifyListeners();
  }
}
