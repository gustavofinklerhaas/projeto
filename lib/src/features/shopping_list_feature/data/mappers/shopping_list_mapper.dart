import 'package:flutter_application_1/src/features/shopping_list_feature/domain/entities/shopping_list.dart';
import 'package:flutter_application_1/src/features/shopping_list_feature/data/dtos/shopping_list_dto.dart';

/// ShoppingListMapper
/// 
/// Responsável pela conversão bidirecional entre Entity e DTO.
/// Segue os princípios de Clean Architecture:
/// - Converte Entity → DTO (para persistência/API)
/// - Converte DTO → Entity (para lógica de negócios)
/// - Não contém lógica de negócio, apenas mapeamento
/// - Testável e sem efeitos colaterais
/// - Trata conversão de DateTime → int milliseconds e vice-versa
/// 
/// Padrão: Mapper centraliza toda conversão entre camadas.
abstract class ShoppingListMapper {
  /// Converte um DTO em uma Entity
  /// 
  /// Usado após ler dados do storage/API.
  /// Converte milliseconds de volta para DateTime.
  /// 
  /// Exemplo:
  ///   final dto = ShoppingListDto.fromMap(jsonData);
  ///   final entity = ShoppingListMapper.toEntity(dto);
  static ShoppingList toEntity(ShoppingListDto dto) {
    return ShoppingList(
      id: dto.id,
      name: dto.name,
      createdAt: DateTime.fromMillisecondsSinceEpoch(dto.createdAtMillis),
    );
  }

  /// Converte uma Entity em um DTO
  /// 
  /// Usado antes de salvar dados no storage/API.
  /// Converte DateTime em milliseconds desde Epoch.
  /// 
  /// Exemplo:
  ///   final entity = ShoppingList(...);
  ///   final dto = ShoppingListMapper.toDto(entity);
  ///   final json = dto.toMap();
  static ShoppingListDto toDto(ShoppingList entity) {
    return ShoppingListDto(
      id: entity.id,
      name: entity.name,
      createdAtMillis: entity.createdAt.millisecondsSinceEpoch,
    );
  }
}
