import '../dtos/shopping_list_share_dto.dart';
import '../../domain/entities/shopping_list_share.dart';

/// Mapper: ShoppingListShare Entity ↔ ShoppingListShare DTO
class ShoppingListShareMapper {
  /// Converte ShoppingListShareDto → ShoppingListShare Entity
  static ShoppingListShare toEntity(ShoppingListShareDto dto) {
    return ShoppingListShare(
      id: dto.id,
      shoppingListId: dto.shoppingListId,
      ownerId: dto.ownerId,
      sharedWithUserId: dto.sharedWithUserId,
      permission: _parsePermission(dto.permission),
      sharedAt: DateTime.parse(dto.sharedAt),
      acceptedAt: dto.acceptedAt != null ? DateTime.parse(dto.acceptedAt!) : null,
      isActive: dto.isActive,
    );
  }

  /// Converte ShoppingListShare Entity → ShoppingListShareDto
  static ShoppingListShareDto toDto(ShoppingListShare entity) {
    return ShoppingListShareDto(
      id: entity.id,
      shoppingListId: entity.shoppingListId,
      ownerId: entity.ownerId,
      sharedWithUserId: entity.sharedWithUserId,
      permission: entity.permission.name,
      sharedAt: entity.sharedAt.toIso8601String(),
      acceptedAt: entity.acceptedAt?.toIso8601String(),
      isActive: entity.isActive,
    );
  }

  /// Parse string para SharePermission enum
  static SharePermission _parsePermission(String value) {
    switch (value.toLowerCase()) {
      case 'view':
        return SharePermission.view;
      case 'edit':
        return SharePermission.edit;
      case 'admin':
        return SharePermission.admin;
      default:
        return SharePermission.view;
    }
  }
}
