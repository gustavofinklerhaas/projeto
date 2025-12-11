import 'package:flutter_application_1/src/features/shopping_list/data/datasources/local_data_source.dart';
import 'package:flutter_application_1/src/features/shopping_list/data/models/shopping_item_model.dart';
import 'package:flutter_application_1/src/features/shopping_list/data/mappers/shopping_item_mapper.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/repositories/shopping_list_repository.dart';

/// ShoppingListRepositoryImpl
/// 
/// Implementação concreta de [ShoppingListRepository].
/// Responsável por:
/// - Comunicação entre Domain e Data layers
/// - Conversão entre Models e Entities
/// - Coordenação de operações com datasources
/// 
/// Segue os princípios de Clean Architecture:
/// - Implementa a interface abstrata do Domain
/// - Usa LocalDataSource para persistência
/// - Converte Models (data) em Entities (domain)
class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final LocalDataSource _localDataSource;

  /// Construtor que recebe a instância de [LocalDataSource]
  /// 
  /// Segue o padrão de injeção de dependência
  ShoppingListRepositoryImpl(this._localDataSource);

  /// Obtém todos os itens da lista de compras
  /// 
  /// Processo:
  /// 1. Solicita dados brutos ao datasource
  /// 2. Converte Maps → Models (DTOs)
  /// 3. Converte Models → Entities (usando Mapper)
  /// 4. Retorna Entities para a camada de negócios
  /// 
  /// Exceções podem ser propagadas do datasource
  @override
  Future<List<ShoppingItem>> getAllItems() async {
    try {
      final itemsMaps = await _localDataSource.getAll();
      
      return itemsMaps
          .map((map) => ShoppingItemModel.fromMap(map))
          .map((model) => ShoppingItemMapper.toEntity(model))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar itens: $e');
    }
  }

  /// Adiciona um novo item à lista de compras
  /// 
  /// Processo:
  /// 1. Obtém todos os itens atuais
  /// 2. Converte a Entity em Model (usando Mapper)
  /// 3. Converte Model em Map
  /// 4. Adiciona à lista
  /// 5. Salva tudo no datasource
  /// 
  /// Parâmetros:
  ///   - item: A entidade ShoppingItem a ser adicionada
  @override
  Future<void> addItem(ShoppingItem item) async {
    try {
      final currentItems = await _localDataSource.getAll();
      
      final model = ShoppingItemMapper.toModel(item);
      currentItems.add(model.toMap());
      
      await _localDataSource.saveAll(currentItems);
    } catch (e) {
      throw Exception('Erro ao adicionar item: $e');
    }
  }

  /// Remove um item da lista de compras pelo ID
  /// 
  /// Processo:
  /// 1. Obtém todos os itens atuais
  /// 2. Filtra removendo o item com o ID especificado
  /// 3. Salva a lista atualizada
  /// 
  /// Parâmetros:
  ///   - id: O identificador único do item a remover
  /// 
  /// Não lança exceção se o item não existir
  @override
  Future<void> removeItem(String id) async {
    try {
      final currentItems = await _localDataSource.getAll();
      
      final updatedItems = currentItems
          .where((item) => item['id'] != id)
          .toList();
      
      await _localDataSource.saveAll(updatedItems);
    } catch (e) {
      throw Exception('Erro ao remover item: $e');
    }
  }

  /// Atualiza um item existente na lista
  /// 
  /// Processo:
  /// 1. Obtém todos os itens atuais
  /// 2. Converte a Entity em Model (usando Mapper)
  /// 3. Converte Model em Map
  /// 4. Procura e atualiza o item com o mesmo ID
  /// 5. Se não encontrar, adiciona como novo
  /// 6. Salva a lista atualizada
  /// 
  /// Parâmetros:
  ///   - item: A entidade ShoppingItem com dados atualizados
  @override
  Future<void> updateItem(ShoppingItem item) async {
    try {
      final currentItems = await _localDataSource.getAll();
      
      final model = ShoppingItemMapper.toModel(item);
      final modelMap = model.toMap();
      
      // Procura e atualiza o item, ou adiciona se não existir
      final itemIndex = currentItems.indexWhere((map) => map['id'] == item.id);
      
      if (itemIndex != -1) {
        currentItems[itemIndex] = modelMap;
      } else {
        currentItems.add(modelMap);
      }
      
      await _localDataSource.saveAll(currentItems);
    } catch (e) {
      throw Exception('Erro ao atualizar item: $e');
    }
  }
}
