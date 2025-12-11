import '../dtos/shopping_item_history_dto.dart';
import '../../domain/entities/shopping_item_history.dart';

/// Mapper: ShoppingItemHistory Entity ↔ ShoppingItemHistory DTO
class ShoppingItemHistoryMapper {
  /// Converte ShoppingItemHistoryDto → ShoppingItemHistory Entity
  static ShoppingItemHistory toEntity(ShoppingItemHistoryDto dto) {
    return ShoppingItemHistory(
      id: dto.id,
      itemId: dto.itemId,
      listId: dto.listId,
      itemName: dto.itemName,
      quantity: dto.quantity,
      unit: dto.unit,
      purchasedAt: DateTime.parse(dto.purchasedAt),
      costPerUnit: dto.costPerUnit,
      storeId: dto.storeId,
    );
  }

  /// Converte ShoppingItemHistory Entity → ShoppingItemHistoryDto
  static ShoppingItemHistoryDto toDto(ShoppingItemHistory entity) {
    return ShoppingItemHistoryDto(
      id: entity.id,
      itemId: entity.itemId,
      listId: entity.listId,
      itemName: entity.itemName,
      quantity: entity.quantity,
      unit: entity.unit,
      purchasedAt: entity.purchasedAt.toIso8601String(),
      costPerUnit: entity.costPerUnit,
      storeId: entity.storeId,
    );
  }
}
