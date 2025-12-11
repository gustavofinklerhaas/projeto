import 'package:flutter_application_1/src/features/user_preferences/data/datasources/user_preferences_local_data_source.dart';
import 'package:flutter_application_1/src/features/user_preferences/data/dtos/user_preferences_dto.dart';
import 'package:flutter_application_1/src/features/user_preferences/data/mappers/user_preferences_mapper.dart';
import 'package:flutter_application_1/src/features/user_preferences/domain/entities/user_preferences.dart';
import 'package:flutter_application_1/src/features/user_preferences/domain/repositories/user_preferences_repository.dart';

/// UserPreferencesRepositoryImpl
///
/// Implementação concreta de [UserPreferencesRepository].
class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  final UserPreferencesLocalDataSource _localDataSource;

  UserPreferencesRepositoryImpl(this._localDataSource);

  @override
  Future<UserPreferences> getPreferences() async {
    try {
      final preferencesMap = await _localDataSource.getPreferences();

      if (preferencesMap == null) {
        // Retorna padrões se não existirem
        return UserPreferencesMapper.toEntity(UserPreferencesDto.defaults());
      }

      final dto = UserPreferencesDto.fromMap(preferencesMap);
      return UserPreferencesMapper.toEntity(dto);
    } catch (e) {
      // Retorna padrões em caso de erro
      return UserPreferencesMapper.toEntity(UserPreferencesDto.defaults());
    }
  }

  @override
  Future<void> savePreferences(UserPreferences preferences) async {
    try {
      final dto = UserPreferencesMapper.toDto(preferences);
      await _localDataSource.savePreferences(dto.toMap());
    } catch (e) {
      throw Exception('Erro ao salvar preferências: $e');
    }
  }
}
