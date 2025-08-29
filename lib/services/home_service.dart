import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeService {
  final _baseUrl = 'https://maps.googleapis.com/maps/api';
  final String _key = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  Future<Position> getCurrentPosition() async {
    try {
      // 1. Check and request permissions
      await _checkLocationPermissions();
      
      // 2. Try native GPS with timeout
      final Position position = await _tryNativeLocation()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Native GPS timeout');
      });

      // 3. If accuracy is poor, fallback to network
      if (position.accuracy > 100) {
        return await _tryNetworkLocation();
      }
      
      return position;
    } catch (e) {
      // Fallback to network if GPS fails
      return await _tryNetworkLocation();
    }
  }

  Future<void> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && 
          permission != LocationPermission.always) {
        throw Exception('Location permissions denied');
      }
    }
  }

  Future<Position> _tryNativeLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future<Position> _tryNetworkLocation() async {
    final url = '$_baseUrl/geolocation/v1/geolocate?key=$_key';
    final resp = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'considerIp': true}),
    ).timeout(const Duration(seconds: 10));

    if (resp.statusCode != 200) {
      throw Exception('Network location failed: ${resp.statusCode}');
    }

    final data = json.decode(resp.body);
    if (data['location'] == null) {
      throw Exception('Network location failed: ${data['error']?['message']}');
    }

    return Position(
      latitude: data['location']['lat'],
      longitude: data['location']['lng'],
      accuracy: (data['accuracy'] as num?)?.toDouble() ?? 100.0,
      timestamp: DateTime.now(),
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  Future<String> getCityFromPosition(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    return placemarks.first.locality ?? '';
  }
}