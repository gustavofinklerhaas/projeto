import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';

/// ShoppingListRepository (Abstract)
/// 
/// Define o contrato (interface) para operações de lista de compras.
/// Segue os princípios de Clean Architecture:
/// - Não conhece implementações concretas
/// - Define apenas o que precisa ser feito
/// - Será implementado na camada Data
abstract class ShoppingListRepository {
  /// Obtém todos os itens da lista de compras
  /// 
  /// Retorna:
  ///   Uma Future contendo uma lista de [ShoppingItem]
  /// 
  /// Pode lançar exceções dependendo da implementação
  Future<List<ShoppingItem>> getAllItems();

  /// Adiciona um novo item à lista de compras
  /// 
  /// Parâmetros:
  ///   - item: O [ShoppingItem] a ser adicionado
  /// 
  /// Pode lançar exceções se houver erro ao adicionar
  Future<void> addItem(ShoppingItem item);

  /// Remove um item da lista de compras
  /// 
  /// Parâmetros:
  ///   - id: O identificador único do item a ser removido
  /// 
  /// Pode lançar exceções se o item não existir ou houver erro
  Future<void> removeItem(String id);

  /// Atualiza um item existente na lista de compras
  /// 
  /// Parâmetros:
  ///   - item: O [ShoppingItem] com os dados atualizados
  /// 
  /// Pode lançar exceções se o item não existir ou houver erro
  Future<void> updateItem(ShoppingItem item);
}
