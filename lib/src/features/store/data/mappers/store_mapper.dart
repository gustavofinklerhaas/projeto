import 'package:flutter_application_1/src/features/store/domain/entities/store.dart';
import 'package:flutter_application_1/src/features/store/data/dtos/store_dto.dart';

/// StoreMapper
/// 
/// Responsável pela conversão bidirecional entre Entity e DTO.
/// Segue os princípios de Clean Architecture:
/// - Converte Entity → DTO (para persistência/API)
/// - Converte DTO → Entity (para lógica de negócios)
/// - Não contém lógica de negócio, apenas mapeamento
/// - Testável e sem efeitos colaterais
/// 
/// Padrão: Mapper centraliza toda conversão entre camadas.
abstract class StoreMapper {
  /// Converte um DTO em uma Entity
  /// 
  /// Usado após ler dados do storage/API.
  /// 
  /// Exemplo:
  ///   final dto = StoreDto.fromMap(jsonData);
  ///   final entity = StoreMapper.toEntity(dto);
  static Store toEntity(StoreDto dto) {
    return Store(
      id: dto.id,
      name: dto.name,
      address: dto.address,
    );
  }

  /// Converte uma Entity em um DTO
  /// 
  /// Usado antes de salvar dados no storage/API.
  /// 
  /// Exemplo:
  ///   final entity = Store(...);
  ///   final dto = StoreMapper.toDto(entity);
  ///   final json = dto.toMap();
  static StoreDto toDto(Store entity) {
    return StoreDto(
      id: entity.id,
      name: entity.name,
      address: entity.address,
    );
  }
}
