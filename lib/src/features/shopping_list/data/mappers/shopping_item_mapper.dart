import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/data/models/shopping_item_model.dart';

/// ShoppingItemMapper
/// 
/// Responsável pela conversão bidirecional entre Entity e DTO.
/// Segue os princípios de Clean Architecture:
/// - Converte Entity → DTO (para persistência)
/// - Converte DTO → Entity (para lógica de negócios)
/// - Não contém lógica de negócio, apenas mapeamento
/// - Testável e sem efeitos colaterais
/// 
/// Padrão: Mapper centraliza toda conversão entre camadas.
abstract class ShoppingItemMapper {
  /// Converte um DTO (Model) em uma Entity
  /// 
  /// Usado após ler dados do storage/API.
  /// 
  /// Exemplo:
  ///   final model = ShoppingItemModel.fromMap(jsonData);
  ///   final entity = ShoppingItemMapper.toEntity(model);
  static ShoppingItem toEntity(ShoppingItemModel model) {
    return ShoppingItem(
      id: model.id,
      title: model.title,
      quantity: model.quantity,
      isDone: model.isDone,
      categoryId: model.categoryId,
      createdAt: model.createdAt != null ? DateTime.parse(model.createdAt!) : DateTime(2024, 1, 1),
    );
  }

  /// Converte uma Entity em um DTO (Model)
  /// 
  /// Usado antes de salvar dados no storage/API.
  /// 
  /// Exemplo:
  ///   final entity = ShoppingItem(...);
  ///   final model = ShoppingItemMapper.toModel(entity);
  ///   final json = model.toMap();
  static ShoppingItemModel toModel(ShoppingItem entity) {
    return ShoppingItemModel(
      id: entity.id,
      title: entity.title,
      quantity: entity.quantity,
      isDone: entity.isDone,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
