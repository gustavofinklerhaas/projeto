import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// UserPreferencesLocalDataSource (Abstract)
///
/// Define o contrato para acesso a dados de preferências armazenados localmente.
abstract class UserPreferencesLocalDataSource {
  /// Obtém as preferências do usuário
  Future<Map<String, dynamic>?> getPreferences();

  /// Salva as preferências do usuário
  Future<void> savePreferences(Map<String, dynamic> preferences);
}

/// UserPreferencesLocalDataSourceImpl
///
/// Implementação concreta de [UserPreferencesLocalDataSource] usando SharedPreferences.
class UserPreferencesLocalDataSourceImpl
    implements UserPreferencesLocalDataSource {
  static const String _storageKey = 'user_preferences';

  final SharedPreferences _preferences;

  UserPreferencesLocalDataSourceImpl(this._preferences);

  @override
  Future<Map<String, dynamic>?> getPreferences() async {
    try {
      final jsonString = _preferences.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    try {
      final jsonString = jsonEncode(preferences);
      await _preferences.setString(_storageKey, jsonString);
    } catch (e) {
      throw Exception('Erro ao salvar preferências: $e');
    }
  }
}
