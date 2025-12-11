import 'package:flutter_application_1/src/features/shopping_item_category/domain/entities/shopping_item_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/data/models/shopping_item_category_dto.dart';

/// ShoppingItemCategoryMapper
/// 
/// Responsável pela conversão bidirecional entre Entity e DTO.
/// Segue os princípios de Clean Architecture:
/// - Converte Entity → DTO (para persistência/API)
/// - Converte DTO → Entity (para lógica de negócios)
/// - Não contém lógica de negócio, apenas mapeamento
/// - Testável e sem efeitos colaterais
/// 
/// Padrão: Mapper centraliza toda conversão entre camadas.
abstract class ShoppingItemCategoryMapper {
  /// Converte um DTO em uma Entity
  /// 
  /// Usado após ler dados do storage/API.
  /// 
  /// Exemplo:
  ///   final dto = ShoppingItemCategoryDto.fromMap(jsonData);
  ///   final entity = ShoppingItemCategoryMapper.toEntity(dto);
  static ShoppingItemCategory toEntity(ShoppingItemCategoryDto dto) {
    return ShoppingItemCategory(
      id: dto.id,
      name: dto.name,
      colorHex: dto.colorHex,
    );
  }

  /// Converte uma Entity em um DTO
  /// 
  /// Usado antes de salvar dados no storage/API.
  /// 
  /// Exemplo:
  ///   final entity = ShoppingItemCategory(...);
  ///   final dto = ShoppingItemCategoryMapper.toDto(entity);
  ///   final json = dto.toMap();
  static ShoppingItemCategoryDto toDto(ShoppingItemCategory entity) {
    return ShoppingItemCategoryDto(
      id: entity.id,
      name: entity.name,
      colorHex: entity.colorHex,
    );
  }
}
