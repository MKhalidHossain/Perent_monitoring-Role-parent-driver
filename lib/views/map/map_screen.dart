import 'dart:async';

import 'package:bbpool/config/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum RideChildStatus { waiting, onboard, dropped, absent }

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.stopName,
    this.childName,
  });

  final String? stopName;
  final String? childName;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  static const LatLng _pickup = LatLng(51.534319, -0.008994);
  static const LatLng _dropoff = LatLng(51.536953, -0.003364);
  static const LatLng _driver = LatLng(51.5349, -0.0065);
  double _currentZoom = 15.5;
  RideChildStatus _status = RideChildStatus.waiting;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding =
        (size.width * 0.04).clamp(16.0, 22.0); // responsive gutters

    final String title = widget.stopName ?? 'Stop 1 - Oak Street';
    final String childName = widget.childName ?? 'Katie Doe';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            size.height * 0.015 + 8,
            horizontalPadding,
            size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildChildCard(childName),
              const SizedBox(height: 18),
              _buildMapSection(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildCard(String childName) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(IconPath.profileIcon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          childName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _statusPill(_status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '5 min away',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0DB765),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.more_horiz, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Next Stop',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.stop_circle, size: 14, color: Colors.grey),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '27 Baker Street, Kensington',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Destination',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.location_city, size: 14, color: Colors.grey),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'North London Collegiate School – Edgware',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statusAction(
                  'Onboard', const Color(0xFF0DB765), RideChildStatus.onboard),
              const SizedBox(width: 8),
              _statusAction(
                  'Drop', const Color(0xFFF9A825), RideChildStatus.dropped),
              const SizedBox(width: 8),
              _statusAction(
                  'Absent', const Color(0xFFE84B4B), RideChildStatus.absent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(Size size) {
    final double mapHeight =
        (size.height * 0.6).clamp(360.0, size.height * 0.7);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: mapHeight,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _driver,
                zoom: 15.5,
              ),
              markers: _buildMarkers(),
              polylines: _buildPolylines(),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                _mapController.complete(controller);
              },
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Column(
                children: [
                  _controlButton(
                    icon: Icons.add,
                    onTap: () => _adjustZoom(0.5),
                  ),
                  const SizedBox(height: 8),
                  _controlButton(
                    icon: Icons.remove,
                    filled: true,
                    onTap: () => _adjustZoom(-0.5),
                  ),
                  const SizedBox(height: 8),
                  _controlButton(
                    icon: Icons.my_location,
                    onTap: _centerOnDriver,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickup,
        infoWindow: const InfoWindow(title: 'Pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoff,
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
      Marker(
        markerId: const MarkerId('driver'),
        position: _driver,
        infoWindow: const InfoWindow(title: 'Driver'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };
  }

  Set<Polyline> _buildPolylines() {
    const route = <LatLng>[
      LatLng(51.5342, -0.0098),
      LatLng(51.5346, -0.0080),
      LatLng(51.5349, -0.0065),
      LatLng(51.5356, -0.0050),
      LatLng(51.5364, -0.0041),
      LatLng(51.5369, -0.0034),
    ];

    return {
      const Polyline(
        polylineId: PolylineId('route'),
        points: route,
        color: Color(0xFF9C88FF),
        width: 6,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  Widget _controlButton({
    required IconData icon,
    VoidCallback? onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF9C88FF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : Colors.black87,
          size: 22,
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

  Widget _statusAction(String label, Color color, RideChildStatus status) {
    final bool selected = _status == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _status = status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border:
                selected ? Border.all(color: Colors.white, width: 1.2) : null,
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

  Future<void> _centerOnDriver() async {
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: _driver, zoom: 16),
      ),
    );
    setState(() {
      _currentZoom = 16;
    });
  }

  Future<void> _adjustZoom(double delta) async {
    final controller = await _mapController.future;
    _currentZoom = (_currentZoom + delta).clamp(12.0, 19.0);
    await controller.animateCamera(
      CameraUpdate.zoomTo(_currentZoom),
    );
    setState(() {});
  }
}
