/// DTO: Store
class StoreDto {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? website;
  final List<String> acceptedPaymentMethods;
  final double? averageRating;
  final int? reviewCount;
  final bool isFavorite;
  final String createdAt;

  StoreDto({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.website,
    required this.acceptedPaymentMethods,
    this.averageRating,
    this.reviewCount,
    required this.isFavorite,
    required this.createdAt,
  });

  /// Serializa para JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'website': website,
        'acceptedPaymentMethods': acceptedPaymentMethods,
        'averageRating': averageRating,
        'reviewCount': reviewCount,
        'isFavorite': isFavorite,
        'createdAt': createdAt,
      };

  /// Desserializa de JSON
  factory StoreDto.fromJson(Map<String, dynamic> json) {
    return StoreDto(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      acceptedPaymentMethods: List<String>.from(json['acceptedPaymentMethods'] as List),
      averageRating: json['averageRating'] != null ? (json['averageRating'] as num).toDouble() : null,
      reviewCount: json['reviewCount'] as int?,
      isFavorite: json['isFavorite'] as bool,
      createdAt: json['createdAt'] as String,
    );
  }
}
