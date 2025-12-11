import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// CategoriesLocalDataSource (Abstract)
///
/// Define o contrato para acesso a dados de categorias armazenados localmente.
abstract class CategoriesLocalDataSource {
  /// Obtém todas as categorias armazenadas localmente
  Future<List<Map<String, dynamic>>> getAll();

  /// Salva uma lista de categorias no armazenamento local
  Future<void> saveAll(List<Map<String, dynamic>> categories);
}

/// CategoriesLocalDataSourceImpl
///
/// Implementação concreta de [CategoriesLocalDataSource] usando SharedPreferences.
/// Responsável pela persistência de dados de categorias.
class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  static const String _storageKey = 'shopping_categories';

  final SharedPreferences _preferences;

  CategoriesLocalDataSourceImpl(this._preferences);

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final jsonString = _preferences.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

      return jsonList
          .map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveAll(List<Map<String, dynamic>> categories) async {
    try {
      if (categories.isEmpty) {
        await _preferences.remove(_storageKey);
      } else {
        final jsonString = jsonEncode(categories);
        await _preferences.setString(_storageKey, jsonString);
      }
    } catch (e) {
      throw Exception('Erro ao salvar categorias: $e');
    }
  }
}
