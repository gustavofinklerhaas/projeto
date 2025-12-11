import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// LocalDataSource (Abstract)
/// 
/// Define o contrato para acesso a dados locais.
/// Interface que será implementada com SharedPreferences.
abstract class LocalDataSource {
  /// Obtém todos os itens armazenados localmente
  /// 
  /// Retorna:
  ///   Uma Future contendo uma lista de Maps com os dados dos itens
  /// 
  /// Pode lançar exceções em caso de erro ao ler
  Future<List<Map<String, dynamic>>> getAll();

  /// Salva uma lista de itens no armazenamento local
  /// 
  /// Parâmetros:
  ///   - items: Lista de Maps com dados dos itens
  /// 
  /// Pode lançar exceções em caso de erro ao salvar
  Future<void> saveAll(List<Map<String, dynamic>> items);
}

/// LocalDataSourceImpl
/// 
/// Implementação concreta de [LocalDataSource] usando SharedPreferences.
/// Responsável pela persistência de dados locais.
/// Segue os princípios de Clean Architecture:
/// - Conhece apenas SharedPreferences
/// - Não conhece entities ou models
/// - Trabalha apenas com tipos primitivos (Map, List, String)
class LocalDataSourceImpl implements LocalDataSource {
  static const String _storageKey = 'shopping_list_items';

  final SharedPreferences _preferences;

  /// Construtor que recebe a instância de SharedPreferences
  /// 
  /// Segue o padrão de injeção de dependência
  LocalDataSourceImpl(this._preferences);

  /// Obtém todos os itens armazenados localmente
  /// 
  /// Recupera a string JSON armazenada em SharedPreferences
  /// e a decodifica em uma lista de Maps.
  /// 
  /// Se nenhum dado estiver armazenado, retorna uma lista vazia.
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
      // Em caso de erro de decodificação, retorna lista vazia
      // Pode ser customizado para lançar exceção específica
      return [];
    }
  }

  /// Salva uma lista de itens no armazenamento local
  /// 
  /// Converte a lista de Maps em uma string JSON
  /// e a armazena em SharedPreferences.
  /// 
  /// Se a lista for vazia, limpa o armazenamento.
  @override
  Future<void> saveAll(List<Map<String, dynamic>> items) async {
    try {
      if (items.isEmpty) {
        await _preferences.remove(_storageKey);
        return;
      }

      final jsonString = jsonEncode(items);
      await _preferences.setString(_storageKey, jsonString);
    } catch (e) {
      throw Exception('Erro ao salvar itens: $e');
    }
  }
}
