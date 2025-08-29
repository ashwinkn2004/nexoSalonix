import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salonix/services/home_service.dart';

final homeServiceProvider = Provider((ref) => HomeService());

final locationPermissionProvider = FutureProvider<bool>((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;
});

final locationProvider = FutureProvider.autoDispose<Map<String, String>>((
  ref,
) async {
  final hasPermission = await ref.read(locationPermissionProvider.future);
  if (!hasPermission) return {'city': 'Unknown', 'state': 'Unknown'};

  try {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    final city = await ref
        .read(homeServiceProvider)
        .getCityFromPosition(position);
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return {
      'city': city,
      'state': placemarks.isNotEmpty
          ? placemarks[0].administrativeArea ?? 'Unknown'
          : 'Unknown',
    };
  } catch (e) {
    return {'city': 'Unknown', 'state': 'Unknown'};
  }
});


/*import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salonix/models/salon_model.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Convert position to city name
  Future<String> getCityFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      return placemarks.first.locality ?? 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  // 2. Convert address to GPS coordinates
  Future<Position> getPositionFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isEmpty) throw Exception('No location found');
      return Position(
        latitude: locations.first.latitude,
        longitude: locations.first.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    } catch (e) {
      throw Exception('Failed to get position: $e');
    }
  }

  // 3. Convert pincode to GPS coordinates
  Future<Position> getPositionFromPincode(String pincode) async {
    return getPositionFromAddress(pincode);
  }

  // 4. Alternative name for getCityFromPosition
  Future<String> getCityFromCoordinates(Position position) async {
    return getCityFromPosition(position);
  }

  // 5. Calculate distance between two points (Haversine formula)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // 6. Get nearby salons within 10km
  Future<List<Map<String, dynamic>>> getNearbySalons(Position userPos) async {
    try {
      final querySnapshot = await _firestore
          .collection('salons')
          .where('isApproved', isEqualTo: true)
          .get(GetOptions(source: Source.server));

      final nearbySalons = <Map<String, dynamic>>[];

      for (final doc in querySnapshot.docs) {
        final salonData = doc.data();
        if (salonData['latitude'] == null || salonData['longitude'] == null) {
          continue;
        }

        final distance = calculateDistance(
          userPos.latitude,
          userPos.longitude,
          salonData['latitude'],
          salonData['longitude'],
        );

        if (distance <= 10) { // 10km radius
          nearbySalons.add({
            ...salonData,
            'distance': distance,
            'salonId': doc.id,
          });
        }
      }

      return nearbySalons;
    } catch (e) {
      print('Error fetching nearby salons: $e');
      return [];
    }
  }

  // 7. Get most visited salons (sorted by visitCount)
  Future<List<Map<String, dynamic>>> getMostVisitedSalons(Position userPos) async {
    final nearbySalons = await getNearbySalons(userPos);
    nearbySalons.sort((a, b) {
      final visitsA = a['visitCount'] ?? 0;
      final visitsB = b['visitCount'] ?? 0;
      return visitsB.compareTo(visitsA); // Descending order
    });
    return nearbySalons;
  }

  // 8. Get current position
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}*/

