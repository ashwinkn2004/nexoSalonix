class BarberModel {
  final String name;
  final String imageUrl;
  final double rating;
  final int reviews;
  final int startingPrice;
  final bool isFavorite;

  BarberModel({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.startingPrice,
    required this.isFavorite,
  });
}
