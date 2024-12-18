import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi tidak aktif.');
    }

    // Periksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi secara permanen ditolak.');
    }

    // Dapatkan posisi saat ini
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Fake GPS detection based on accuracy and speed
    if (_isFakeGPS(position)) {
      throw Exception('Kemungkinan lokasi palsu terdeteksi.');
    }

    return position;
  }

  bool _isFakeGPS(Position position) {
    // Check if GPS accuracy is too low (assuming threshold as 30 meters)
    if (position.accuracy > 30) {
      print("Lokasi dengan akurasi rendah terdeteksi, kemungkinan GPS palsu.");
      return true;
    }

    // Check for extremely high speed (likely fake GPS)
    if (position.speed > 15) { // speed in m/s, 15 m/s is roughly 54 km/h
      print("Kecepatan sangat tinggi terdeteksi, kemungkinan GPS palsu.");
      return true;
    }

    // Check for unnatural location changes (you can set a threshold for distance/time)
    // For simplicity, we assume if the position changes too much in a short time (e.g. > 1000 meters in 10 seconds)
    if (position.timestamp != null && _lastPosition != null) {
      final timeDiff = position.timestamp!.difference(_lastPosition!.timestamp!).inSeconds;
      final dist = Geolocator.distanceBetween(
        _lastPosition!.latitude, _lastPosition!.longitude,
        position.latitude, position.longitude
      );
      if (timeDiff < 10 && dist > 1000) { // 1000 meters in 10 seconds
        print("Perubahan lokasi yang tidak wajar terdeteksi.");
        return true;
      }
    }

    _lastPosition = position;
    return false;
  }

  Position? _lastPosition;
}
