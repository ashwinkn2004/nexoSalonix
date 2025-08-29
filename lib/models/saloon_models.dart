class SalonModel {
  final String id;
  final String name;
  final String image;
  final String address;
  final double rating;
  final double distance;
  final double latitude;
  final double longitude;

  const SalonModel({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.rating,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  factory SalonModel.fromMap(Map<String, dynamic> data) {
    return SalonModel(
      id: data['id']?.toString() ?? '',
      name: data['name'] ?? 'Unnamed Salon',
      image: data['image'] ?? 'assets/welcome.jpg',
      address: data['address'] ?? 'Unknown Address',
      rating: (data['rating'] ?? 0).toDouble(),
      distance: (data['distance'] ?? 0).toDouble(),
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
    );
  }
}
