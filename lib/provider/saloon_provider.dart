import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonix/models/saloon_models.dart';

// Simulated fetch - replace with Firestore later
final salonListProvider = FutureProvider<List<SalonModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 400)); // simulate loading

  return [
    SalonModel(
      id: '1',
      name: 'Glow & Shine',
      image: 'assets/welcome.jpg',
      address: 'MG Road, Kochi',
      rating: 4.6,
      distance: 0.8,
      latitude: 9.9816,
      longitude: 76.2824,
    ),
    SalonModel(
      id: '2',
      name: 'Bliss Salon',
      image: 'assets/welcome.jpg',
      address: 'Panampilly Nagar',
      rating: 4.2,
      distance: 1.1,
      latitude: 9.9667,
      longitude: 76.2995,
    ),
    SalonModel(
      id: '3',
      name: 'The Hair Lounge',
      image: 'assets/welcome.jpg',
      address: 'Vyttila, Kochi',
      rating: 4.8,
      distance: 2.4,
      latitude: 9.9610,
      longitude: 76.3140,
    ),
    SalonModel(
      id: '4',
      name: 'Urban Edge Salon',
      image: 'assets/welcome.jpg',
      address: 'Edapally, Kochi',
      rating: 4.5,
      distance: 3.2,
      latitude: 10.0270,
      longitude: 76.3077,
    ),
    SalonModel(
      id: '5',
      name: 'Style Studio',
      image: 'assets/welcome.jpg',
      address: 'Kadavanthra, Kochi',
      rating: 4.1,
      distance: 1.7,
      latitude: 9.9622,
      longitude: 76.3016,
    ),
    SalonModel(
      id: '6',
      name: 'The Barber Club',
      image: 'assets/welcome.jpg',
      address: 'Palarivattom, Kochi',
      rating: 4.9,
      distance: 2.9,
      latitude: 10.0113,
      longitude: 76.3032,
    ),
    SalonModel(
      id: '7',
      name: 'Royal Cuts',
      image: 'assets/welcome.jpg',
      address: 'Fort Kochi',
      rating: 4.3,
      distance: 4.1,
      latitude: 9.9667,
      longitude: 76.2421,
    ),
    SalonModel(
      id: '8',
      name: 'GlowUp Studio',
      image: 'assets/welcome.jpg',
      address: 'Kakkanad, Kochi',
      rating: 4.4,
      distance: 3.5,
      latitude: 10.0129,
      longitude: 76.3610,
    ),
  ];
});
