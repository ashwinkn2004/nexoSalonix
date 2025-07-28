import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SalonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // === 1. Get Current Position ===
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // === 2. Convert position to city ===
  Future<String> getCityFromPosition(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? 'Unknown';
    }
    return 'Unknown';
  }

  // === 3. Convert address/pincode to position ===
  Future<Position> getPositionFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isEmpty) {
      throw Exception('No matching location found for address');
    }

    final loc = locations.first;
    return Position(
      latitude: loc.latitude,
      longitude: loc.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  // === 4. Convert pincode to position ===
  Future<Position> getPositionFromPincode(String pincode) {
    return getPositionFromAddress(pincode);
  }

  // === 5. Get city from coordinates ===
  Future<String> getCityFromCoordinates(Position position) {
    return getCityFromPosition(position);
  }

  // === 6. Calculate distance using Haversine ===
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius in km
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * pi / 180;

  // === 7. Get nearby salons within 10 km ===
  Future<List<Map<String, dynamic>>> getNearbySalons(Position userPos) async {
    final snapshot = await _firestore
        .collection('salons')
        .where('isApproved', isEqualTo: true)
        .get(const GetOptions(source: Source.server));

    final List<Map<String, dynamic>> nearbySalons = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final location = data['location'];

      if (location == null ||
          location['latitude'] == null ||
          location['longitude'] == null)
        continue;

      final lat = location['latitude'];
      final lon = location['longitude'];

      final distance = calculateDistance(
        userPos.latitude,
        userPos.longitude,
        lat,
        lon,
      );

      if (distance <= 10) {
        nearbySalons.add({...data, 'salonId': doc.id, 'distance': distance});
      }
    }

    return nearbySalons;
  }

  // === 8. Get most visited salons nearby ===
  Future<List<Map<String, dynamic>>> getMostVisitedSalons(
    Position userPos,
  ) async {
    final nearbySalons = await getNearbySalons(userPos);
    nearbySalons.sort((a, b) {
      final aCount = a['visitCount'] ?? 0;
      final bCount = b['visitCount'] ?? 0;
      return bCount.compareTo(aCount);
    });
    return nearbySalons;
  }
}
