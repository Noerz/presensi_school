import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_school/app/core/widgets/maps/location_service.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng, bool) onLocationFetched;

  const MapWidget({Key? key, required this.onLocationFetched})
      : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? currentLocation;
  final LatLng schoolLocation = LatLng(-6.352300, 106.734200); // Lokasi sekolah
  final double radiusInMeters = 100; // Radius dalam meter
  bool isWithinRadius = false; // Status radius

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        currentLocation = userLocation;

        // Hitung jarak pengguna dengan sekolah
        final double distanceToSchool = calculateDistance(
          userLocation.latitude,
          userLocation.longitude,
          schoolLocation.latitude,
          schoolLocation.longitude,
        );

        // Validasi lokasi dalam radius
        isWithinRadius = distanceToSchool <= radiusInMeters;
      });

      // Kirim lokasi dan status radius ke controller
      widget.onLocationFetched(userLocation, isWithinRadius);
    } catch (e) {
      debugPrint('Error fetching location: $e');
      // Optionally show a message to the user that fake GPS was detected
      if (e.toString().contains("Kemungkinan lokasi palsu")) {
        debugPrint("Fake GPS detected, please disable fake GPS.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: currentLocation,
                    zoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentLocation!,
                          builder: (ctx) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                        Marker(
                          point: schoolLocation,
                          builder: (ctx) => const Icon(
                            Icons.school,
                            color: Colors.blue,
                            size: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isWithinRadius
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        "Anda berada di dalam radius sekolah.",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : contentNotInRadius(),
            ],
          );
  }

  Widget contentNotInRadius() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.red),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.red,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Anda berada di luar lokasi area sekolah. Silakan menuju lokasi sekolah untuk menggunakan fitur ini.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}


// Fungsi Haversine untuk menghitung jarak
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371000; // Radius Bumi dalam meter
  double dLat = degToRad(lat2 - lat1);
  double dLon = degToRad(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(degToRad(lat1)) * cos(degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double degToRad(double deg) {
  return deg * (pi / 180);
}


