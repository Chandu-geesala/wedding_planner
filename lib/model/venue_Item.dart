class Venue {
  final String id;
  final String name;
  final String location;
  final int price;
  final int minCapacity;
  final int maxCapacity;
  final String imageAsset;
  final double rating;
  final List<String> amenities;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.minCapacity,
    required this.maxCapacity,
    required this.imageAsset,
    required this.rating,
    required this.amenities,
  });
}
