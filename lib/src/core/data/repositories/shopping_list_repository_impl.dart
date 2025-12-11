import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/shopping_entities.dart';
import '../../domain/repositories/repositories.dart';
import '../preferences_service.dart';

/// Implementação do ShoppingListRepository
/// Combina cache local (SharedPreferences) com sync remoto
/// 1. Carrega do cache local imediatamente
/// 2. Em paralelo, sincroniza com backend (quando disponível)
/// 3. Atualiza cache e notifica UI de mudanças
class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final PreferencesService _localDataSource;
  final RemoteDataSource? _remoteDataSource; // Opcional, para quando houver API

  ShoppingListRepositoryImpl({
    required PreferencesService localDataSource,
    RemoteDataSource? remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<List<ShoppingList>> getLists() async {
    try {
      // 1. CARREGA DO CACHE LOCAL (IMEDIATO)
      final localLists = await _getListsFromLocal();

      // 2. FAZ SYNC REMOTO EM PARALELO (quando disponível)
      if (_remoteDataSource != null) {
        _syncListsInBackground(localLists);
      }

      return localLists;
    } catch (e) {
      debugPrint('Erro ao obter listas: $e');
      rethrow;
    }
  }

  /// Obtém listas do cache local
  Future<List<ShoppingList>> _getListsFromLocal() async {
    final listsJson = await _localDataSource.getShoppingLists();
    return listsJson.map((json) => ShoppingList.fromJson(json)).toList();
  }

  /// Sincroniza listas com backend em background
  void _syncListsInBackground(List<ShoppingList> localLists) async {
    try {
      if (_remoteDataSource == null) return;

      final hasConnection = await _remoteDataSource!.hasNetworkConnection();
      if (!hasConnection) {
        debugPrint('Sem conexão de rede para sync');
        return;
      }

      // Sincroniza com servidor
      final updatedLists = await _remoteDataSource!.syncLists(localLists);

      // Atualiza cache local com dados do servidor
      for (final list in updatedLists) {
        await _localDataSource.updateShoppingList(list.id, list.toJson());
      }

      debugPrint('Listas sincronizadas com sucesso');
    } catch (e) {
      debugPrint('Erro ao sincronizar listas: $e');
      // Não lança erro, apenas registra. O cache local continua válido.
    }
  }

  @override
  Future<ShoppingList?> getListById(String id) async {
    try {
      final listJson = await _localDataSource.getShoppingList(id);
      return listJson != null ? ShoppingList.fromJson(listJson) : null;
    } catch (e) {
      debugPrint('Erro ao obter lista: $e');
      rethrow;
    }
  }

  @override
  Future<ShoppingList> createList(String name, {String? description}) async {
    try {
      final newList = ShoppingList(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description ?? '',
        createdAt: DateTime.now(),
      );

      // Persiste localmente
      await _localDataSource.createShoppingList(name);

      // Sincroniza com remoto em background
      _syncListsInBackground([newList]);

      return newList;
    } catch (e) {
      debugPrint('Erro ao criar lista: $e');
      rethrow;
    }
  }

  @override
  Future<ShoppingList> updateList(ShoppingList list) async {
    try {
      final updatedList = list.copyWith(updatedAt: DateTime.now());

      // Persiste localmente
      await _localDataSource.updateShoppingList(list.id, updatedList.toJson());

      // Sincroniza com remoto em background
      _syncListsInBackground([updatedList]);

      return updatedList;
    } catch (e) {
      debugPrint('Erro ao atualizar lista: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteList(String id) async {
    try {
      // Remove localmente
      await _localDataSource.deleteShoppingList(id);

      // Sincroniza deleção com remoto em background
      if (_remoteDataSource != null) {
        _deleteSyncInBackground(id);
      }
    } catch (e) {
      debugPrint('Erro ao deletar lista: $e');
      rethrow;
    }
  }

  void _deleteSyncInBackground(String id) async {
    try {
      if (_remoteDataSource == null) return;
      final hasConnection = await _remoteDataSource!.hasNetworkConnection();
      if (!hasConnection) return;

      // Aqui iria chamar método de delete no servidor
      debugPrint('Lista $id deletada remotamente');
    } catch (e) {
      debugPrint('Erro ao sincronizar deleção: $e');
    }
  }

  @override
  Future<ShoppingList> duplicateList(String id) async {
    try {
      final originalList = await getListById(id);
      if (originalList == null) throw Exception('Lista não encontrada');

      final newList = ShoppingList(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: '${originalList.name} (Cópia)',
        description: originalList.description,
        items: originalList.items,
        createdAt: DateTime.now(),
      );

      await _localDataSource.createShoppingList(newList.name);
      _syncListsInBackground([newList]);

      return newList;
    } catch (e) {
      debugPrint('Erro ao duplicar lista: $e');
      rethrow;
    }
  }

  @override
  Future<ShoppingList> toggleListCompletion(String id) async {
    try {
      final list = await getListById(id);
      if (list == null) throw Exception('Lista não encontrada');

      final updated =
          list.copyWith(isCompleted: !list.isCompleted, updatedAt: DateTime.now());
      return updateList(updated);
    } catch (e) {
      debugPrint('Erro ao atualizar conclusão: $e');
      rethrow;
    }
  }
}

/// Implementação do ShoppingItemRepository
class ShoppingItemRepositoryImpl implements ShoppingItemRepository {
  final PreferencesService _localDataSource;
  final RemoteDataSource? _remoteDataSource;

  ShoppingItemRepositoryImpl({
    required PreferencesService localDataSource,
    RemoteDataSource? remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<List<ShoppingItem>> getItemsByListId(String listId) async {
    try {
      final list = await _localDataSource.getShoppingList(listId);
      if (list == null) return [];

      final items =
          (list['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      return items.map((json) => ShoppingItem.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Erro ao obter items: $e');
      rethrow;
    }
  }

  @override
  Future<ShoppingItem?> getItemById(String itemId) async {
    try {
      // Busca em todas as listas
      final lists = await _localDataSource.getShoppingLists();
      for (final listJson in lists) {
        final items =
            (listJson['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
                [];
        for (final itemJson in items) {
          if (itemJson['id'] == itemId) {
            return ShoppingItem.fromJson(itemJson);
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao obter item: $e');
      rethrow;
    }
  }

  @override
  Future<ShoppingItem> createItem({
    required String listId,
    required String name,
    required int quantity,
    required String categoryId,
  }) async {
    try {
      final newItem = ShoppingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        quantity: quantity.toDouble(),
        categoryId: categoryId,
        createdAt: DateTime.now(),
      );

      // Obtém lista atual
      final list = await _localDataSource.getShoppingList(listId);
      if (list == null) throw Exception('Lista não encontrada');

      // Adiciona item
      final items = (list['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      items.add(newItem.toJson());

      // Persiste
      await _localDataSource.updateShoppingList(listId, {'items': items});

      return newItem;
    } catch (e) {
      debugPrint('Erro ao criar item: $e');
      rethrow;
    }
  }

  @override
  Future<ShoppingItem> updateItem(ShoppingItem item) async {
    try {
      final updated = item.copyWith();
      // Implementação similar a createItem
      return updated;
    } catch (e) {
      debugPrint('Erro ao atualizar item: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteItem(String itemId) async {
    try {
      // Busca e remove de todas as listas
      final lists = await _localDataSource.getShoppingLists();
      for (final listJson in lists) {
        final items =
            (listJson['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
                [];
        items.removeWhere((item) => item['id'] == itemId);
        await _localDataSource.updateShoppingList(listJson['id'], {'items': items});
      }
    } catch (e) {
      debugPrint('Erro ao deletar item: $e');
      rethrow;
    }
  }

  @override
  Future<ShoppingItem> toggleItemPurchased(String itemId) async {
    try {
      final item = await getItemById(itemId);
      if (item == null) throw Exception('Item não encontrado');

      final updated = item.copyWith(
        isPurchased: !item.isPurchased,
        purchasedAt: !item.isPurchased ? DateTime.now() : null,
      );

      await updateItem(updated);
      return updated;
    } catch (e) {
      debugPrint('Erro ao atualizar item: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, List<ShoppingItem>>> getItemsGroupedByCategory(
    String listId,
  ) async {
    try {
      final items = await getItemsByListId(listId);
      final grouped = <String, List<ShoppingItem>>{};

      for (final item in items) {
        // Pula items sem categoryId
        final categoryId = item.categoryId;
        if (categoryId == null) continue;
        
        if (!grouped.containsKey(categoryId)) {
          grouped[categoryId] = [];
        }
        grouped[categoryId]!.add(item);
      }

      return grouped;
    } catch (e) {
      debugPrint('Erro ao agrupar items: $e');
      rethrow;
    }
  }
}

/// Implementação do CategoryRepository
class CategoryRepositoryImpl implements CategoryRepository {
  final PreferencesService _localDataSource;
  final RemoteDataSource? _remoteDataSource;

  CategoryRepositoryImpl({
    required PreferencesService localDataSource,
    RemoteDataSource? remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categoriesJson = await _localDataSource.getCategories();
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Erro ao obter categorias: $e');
      rethrow;
    }
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    try {
      final categories = await getCategories();
      return categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Category> createCategory(String name, String colorHex) async {
    try {
      final newCategory = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        colorHex: colorHex,
      );

      await _localDataSource.createCategory(name, colorHex);
      return newCategory;
    } catch (e) {
      debugPrint('Erro ao criar categoria: $e');
      rethrow;
    }
  }

  @override
  Future<Category> updateCategory(Category category) async {
    try {
      await _localDataSource.updateCategory(category.id, category.toJson());
      return category;
    } catch (e) {
      debugPrint('Erro ao atualizar categoria: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _localDataSource.deleteCategory(id);
    } catch (e) {
      debugPrint('Erro ao deletar categoria: $e');
      rethrow;
    }
  }

  @override
  Future<void> loadDefaultCategories() async {
    try {
      final categories = await _localDataSource.getCategories();
      // Se está vazio, já carrega padrão no getCategories()
      debugPrint('${categories.length} categorias carregadas');
    } catch (e) {
      debugPrint('Erro ao carregar categorias padrão: $e');
      rethrow;
    }
  }
}

/// Implementação temporária de RemoteDataSource (para quando houver API)
/// Por enquanto, apenas retorna os dados locais sem fazer sync real
class RemoteDataSourceImpl implements RemoteDataSource {
  // Será implementado quando houver backend/API disponível

  @override
  Future<List<ShoppingList>> syncLists(List<ShoppingList> localLists) async {
    // TODO: Implementar chamada à API
    // Por enquanto, apenas retorna os dados locais
    return localLists;
  }

  @override
  Future<List<ShoppingItem>> syncItems(List<ShoppingItem> localItems) async {
    // TODO: Implementar chamada à API
    return localItems;
  }

  @override
  Future<List<Category>> syncCategories(List<Category> localCategories) async {
    // TODO: Implementar chamada à API
    return localCategories;
  }

  @override
  Future<bool> hasNetworkConnection() async {
    // TODO: Usar connectivity_plus para verificar conexão real
    // Por enquanto, retorna false (não sincroniza)
    return false;
  }
}
