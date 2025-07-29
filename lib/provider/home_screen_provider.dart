import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salonix/services/home_service.dart';

// Provider for HomeService instance
final homeServiceProvider = Provider((ref) => HomeService());

// Provider for current user position
final positionProvider = FutureProvider<Position>((ref) async {
  // Calls HomeService.getCurrentPosition
  return await ref.watch(homeServiceProvider).getCurrentPosition();
});

// Provider for city name
final cityProvider = FutureProvider<String>((ref) async {
  final position = await ref.watch(positionProvider.future);
  // Calls HomeService.getCityFromPosition
  return await ref.watch(homeServiceProvider).getCityFromPosition(position);
});

// Provider for search query
final searchQueryProvider = StateProvider<String?>((ref) => null);

// Provider for nearby salons
final nearbySalonsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final homeService = ref.watch(homeServiceProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  Position position;
  try {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Calls HomeService.getPositionFromAddress (or getPositionFromPincode internally)
      position = await homeService.getPositionFromAddress(searchQuery);
    } else {
      // Calls HomeService.getCurrentPosition (via positionProvider)
      position = await ref.watch(positionProvider.future);
    }
    // Calls HomeService.getNearbySalons (which internally uses calculateDistance)
    return await homeService.getNearbySalons(position);
  } catch (e) {
    throw Exception('Failed to fetch nearby salons: $e');
  }
});

// Provider for most visited salons
final mostVisitedSalonsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final homeService = ref.watch(homeServiceProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  Position position;
  try {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Calls HomeService.getPositionFromAddress (or getPositionFromPincode internally)
      position = await homeService.getPositionFromAddress(searchQuery);
    } else {
      // Calls HomeService.getCurrentPosition (via positionProvider)
      position = await ref.watch(positionProvider.future);
    }
    // Calls HomeService.getMostVisitedSalons (which internally calls getNearbySalons)
    return await homeService.getMostVisitedSalons(position);
  } catch (e) {
    throw Exception('Failed to fetch most visited salons: $e');
  }
});
