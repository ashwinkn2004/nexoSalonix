import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

class HomeService {
  // 1. Get the user's current GPS location
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check and request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // 2. Convert position to city name
  Future<String> getCityFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      return placemarks.isNotEmpty
          ? placemarks[0].locality ?? 'Unknown'
          : 'Unknown';
    } catch (e) {
      print('Error in getCityFromPosition: $e');
      return 'Unknown';
    }
  }

  // 3. Convert address or pincode to GPS coordinates
  Future<Position> getPositionFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        throw Exception('No location found for the address: $address');
      }
      return Position(
        latitude: locations[0].latitude,
        longitude: locations[0].longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    } catch (e) {
      throw Exception('Error converting address to position: $e');
    }
  }

  // 4. Convert pincode to GPS position (calls getPositionFromAddress)
  Future<Position> getPositionFromPincode(String pincode) async {
    return await getPositionFromAddress(pincode);
  }

  // 5. Convert coordinates to city name (alias for getCityFromPosition)
  Future<String> getCityFromCoordinates(Position position) async {
    return await getCityFromPosition(position);
  }

  // 6. Calculate distance between two points using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the earth in km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c; // Distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  // 7. Fetch approved salons within 10 km of the user
  Future<List<Map<String, dynamic>>> getNearbySalons(Position userPos) async {
    try {
      print(
        'Fetching nearby salons for position: ${userPos.latitude}, ${userPos.longitude}',
      );
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('salons')
          .where('isApproved', isEqualTo: true)
          .get(const GetOptions(source: Source.server));

      List<Map<String, dynamic>> salons = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['location'] != null) {
          GeoPoint salonGeoPoint = data['location'] as GeoPoint;
          double distance = calculateDistance(
            userPos.latitude,
            userPos.longitude,
            salonGeoPoint.latitude,
            salonGeoPoint.longitude,
          );

          if (distance <= 10) {
            data['distance'] = distance;
            data['salonId'] = doc.id;
            salons.add(data);
          }
        } else {
          print('Skipping salon ${doc.id}: No valid location');
        }
      }

      print('Found ${salons.length} salons within 10 km');
      return salons;
    } catch (e) {
      print('Error fetching nearby salons: $e');
      return [];
    }
  }

  // 8. Fetch nearby salons sorted by visitCount
  Future<List<Map<String, dynamic>>> getMostVisitedSalons(
    Position userPos,
  ) async {
    try {
      List<Map<String, dynamic>> salons = await getNearbySalons(userPos);
      salons.sort((a, b) {
        int visitCountA = a['visitCount'] ?? 0;
        int visitCountB = b['visitCount'] ?? 0;
        return visitCountB.compareTo(visitCountA); // Descending order
      });
      print('Sorted ${salons.length} salons by visitCount');
      return salons;
    } catch (e) {
      print('Error fetching most visited salons: $e');
      return [];
    }
  }
}
