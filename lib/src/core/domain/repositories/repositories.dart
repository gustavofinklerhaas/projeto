import '../entities/shopping_entities.dart';

/// Interface do Repository de Listas de Compras
/// Define contrato que toda implementação deve seguir
abstract class ShoppingListRepository {
  /// Obtém todas as listas do cache local
  /// Carrega imediatamente do cache
  /// Em paralelo, faz sync remoto (quando API disponível)
  Future<List<ShoppingList>> getLists();

  /// Obtém uma lista específica pelo ID
  Future<ShoppingList?> getListById(String id);

  /// Cria nova lista de compras
  /// Persiste localmente e sincroniza com remoto (quando disponível)
  Future<ShoppingList> createList(String name, {String? description});

  /// Atualiza uma lista de compras existente
  Future<ShoppingList> updateList(ShoppingList list);

  /// Deleta uma lista de compras
  Future<void> deleteList(String id);

  /// Duplica uma lista de compras
  Future<ShoppingList> duplicateList(String id);

  /// Marca lista como completa/incompleta
  Future<ShoppingList> toggleListCompletion(String id);
}

/// Interface do Repository de Items de Compra
/// Define contrato que toda implementação deve seguir
abstract class ShoppingItemRepository {
  /// Obtém todos os items de uma lista
  Future<List<ShoppingItem>> getItemsByListId(String listId);

  /// Obtém um item específico
  Future<ShoppingItem?> getItemById(String itemId);

  /// Cria novo item em uma lista
  Future<ShoppingItem> createItem({
    required String listId,
    required String name,
    required int quantity,
    required String categoryId,
  });

  /// Atualiza um item
  Future<ShoppingItem> updateItem(ShoppingItem item);

  /// Deleta um item
  Future<void> deleteItem(String itemId);

  /// Marca item como comprado/não comprado
  Future<ShoppingItem> toggleItemPurchased(String itemId);

  /// Obtém items de uma lista agrupados por categoria
  Future<Map<String, List<ShoppingItem>>> getItemsGroupedByCategory(String listId);
}

/// Interface do Repository de Categorias
/// Define contrato que toda implementação deve seguir
abstract class CategoryRepository {
  /// Obtém todas as categorias
  Future<List<Category>> getCategories();

  /// Obtém uma categoria específica
  Future<Category?> getCategoryById(String id);

  /// Cria nova categoria
  Future<Category> createCategory(String name, String colorHex);

  /// Atualiza uma categoria
  Future<Category> updateCategory(Category category);

  /// Deleta uma categoria
  Future<void> deleteCategory(String id);

  /// Carrega categorias padrão (primeira execução)
  Future<void> loadDefaultCategories();
}

/// Interface para Data Source Remoto (API)
/// Usado para sincronização quando backend estiver disponível
abstract class RemoteDataSource {
  /// Sincroniza listas locais com servidor
  /// Retorna listas atualizadas do servidor
  Future<List<ShoppingList>> syncLists(List<ShoppingList> localLists);

  /// Sincroniza items locais com servidor
  Future<List<ShoppingItem>> syncItems(List<ShoppingItem> localItems);

  /// Sincroniza categorias locais com servidor
  Future<List<Category>> syncCategories(List<Category> localCategories);

  /// Verifica se há conexão com servidor
  Future<bool> hasNetworkConnection();
}
