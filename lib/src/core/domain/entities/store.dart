import 'package:uuid/uuid.dart';

/// Entity: Lojas onde o usuário compra
class Store {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? website;
  final List<String> acceptedPaymentMethods;
  final double? averageRating;
  final int reviewCount;
  final bool isFavorite;
  final DateTime createdAt;

  Store({
    String? id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.website,
    this.acceptedPaymentMethods = const ['cash', 'debit', 'credit'],
    this.averageRating,
    this.reviewCount = 0,
    this.isFavorite = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

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
        'createdAt': createdAt.toIso8601String(),
      };

  /// Desserializa de JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String?,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      acceptedPaymentMethods: List<String>.from(
        json['acceptedPaymentMethods'] as List? ?? ['cash', 'debit', 'credit'],
      ),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  /// Cópia com mudanças
  Store copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? website,
    List<String>? acceptedPaymentMethods,
    double? averageRating,
    int? reviewCount,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      acceptedPaymentMethods:
          acceptedPaymentMethods ?? this.acceptedPaymentMethods,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Calcula distância em KM (mock)
  /// Em produção, usar package:geolocator
  double getDistanceKm(double userLat, double userLng) {
    // Fórmula de Haversine simplificada
    const earthRadiusKm = 6371;
    final dLat = (latitude - userLat) * 3.14159 / 180;
    final dLng = (longitude - userLng) * 3.14159 / 180;
    final a = (dLat * dLat + dLng * dLng) / 4;
    return earthRadiusKm * 2 * a;
  }

  @override
  String toString() => 'Store(id: $id, name: $name, address: $address)';
}
