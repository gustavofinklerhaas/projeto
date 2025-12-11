import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/repositories/shopping_list_repository.dart';

/// UpdateItem UseCase
/// 
/// Responsável por atualizar um item existente na lista de compras.
/// Segue o padrão de Clean Architecture:
/// - Encapsula a lógica de atualização
/// - Pode validar dados antes de atualizar
/// - Permite testes isolados
/// 
/// Padrão: O método [call] permite chamar a classe como função
class UpdateItem {
  final ShoppingListRepository _repository;

  /// Construtor que recebe a instância do repositório
  /// 
  /// Segue injeção de dependência
  UpdateItem(this._repository);

  /// Executa o caso de uso
  /// 
  /// Parâmetros:
  ///   - item: O [ShoppingItem] com dados atualizados
  /// 
  /// Retorna:
  ///   Uma Future que completa quando o item é atualizado
  /// 
  /// Uso:
  ///   final usecase = UpdateItem(repository);
  ///   await usecase(updatedShoppingItem);
  Future<void> call(ShoppingItem item) {
    return _repository.updateItem(item);
  }
}
