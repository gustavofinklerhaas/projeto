import 'package:flutter_application_1/src/features/user_preferences/domain/entities/user_preferences.dart';
import 'package:flutter_application_1/src/features/user_preferences/data/dtos/user_preferences_dto.dart';

/// UserPreferencesMapper
/// 
/// Responsável pela conversão bidirecional entre Entity e DTO.
/// Segue os princípios de Clean Architecture:
/// - Converte Entity → DTO (para persistência/API)
/// - Converte DTO → Entity (para lógica de negócios)
/// - Não contém lógica de negócio, apenas mapeamento
/// - Testável e sem efeitos colaterais
/// 
/// Padrão: Mapper centraliza toda conversão entre camadas.
abstract class UserPreferencesMapper {
  /// Converte um DTO em uma Entity
  /// 
  /// Usado após ler dados do storage/API.
  /// 
  /// Exemplo:
  ///   final dto = UserPreferencesDto.fromMap(jsonData);
  ///   final entity = UserPreferencesMapper.toEntity(dto);
  static UserPreferences toEntity(UserPreferencesDto dto) {
    return UserPreferences(
      themeMode: dto.themeMode,
      sortMode: dto.sortMode,
      notificationsEnabled: dto.notificationsEnabled,
    );
  }

  /// Converte uma Entity em um DTO
  /// 
  /// Usado antes de salvar dados no storage/API.
  /// 
  /// Exemplo:
  ///   final entity = UserPreferences(...);
  ///   final dto = UserPreferencesMapper.toDto(entity);
  ///   final json = dto.toMap();
  static UserPreferencesDto toDto(UserPreferences entity) {
    return UserPreferencesDto(
      themeMode: entity.themeMode,
      sortMode: entity.sortMode,
      notificationsEnabled: entity.notificationsEnabled,
    );
  }
}
