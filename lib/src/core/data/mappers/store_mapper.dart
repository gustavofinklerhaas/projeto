import '../dtos/store_dto.dart';
import '../../domain/entities/store.dart';

/// Mapper: Store Entity ↔ Store DTO
class StoreMapper {
  /// Converte StoreDto → Store Entity
  static Store toEntity(StoreDto dto) {
    return Store(
      id: dto.id,
      name: dto.name,
      address: dto.address,
      latitude: dto.latitude,
      longitude: dto.longitude,
      phone: dto.phone,
      website: dto.website,
      acceptedPaymentMethods: dto.acceptedPaymentMethods,
      averageRating: dto.averageRating,
      reviewCount: dto.reviewCount,
      isFavorite: dto.isFavorite,
      createdAt: DateTime.parse(dto.createdAt),
    );
  }

  /// Converte Store Entity → StoreDto
  static StoreDto toDto(Store entity) {
    return StoreDto(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      phone: entity.phone,
      website: entity.website,
      acceptedPaymentMethods: entity.acceptedPaymentMethods,
      averageRating: entity.averageRating,
      reviewCount: entity.reviewCount,
      isFavorite: entity.isFavorite,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
