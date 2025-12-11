import 'package:flutter_application_1/src/features/shopping_list/domain/repositories/shopping_list_repository.dart';

/// RemoveItem UseCase
/// 
/// Responsável por remover um item da lista de compras.
/// Segue o padrão de Clean Architecture:
/// - Encapsula a lógica de remoção
/// - Trabalha apenas com IDs
/// - Permite testes isolados
/// 
/// Padrão: O método [call] permite chamar a classe como função
class RemoveItem {
  final ShoppingListRepository _repository;

  /// Construtor que recebe a instância do repositório
  /// 
  /// Segue injeção de dependência
  RemoveItem(this._repository);

  /// Executa o caso de uso
  /// 
  /// Parâmetros:
  ///   - id: O identificador único do item a remover
  /// 
  /// Retorna:
  ///   Uma Future que completa quando o item é removido
  /// 
  /// Uso:
  ///   final usecase = RemoveItem(repository);
  ///   await usecase('item-id-123');
  Future<void> call(String id) {
    return _repository.removeItem(id);
  }
}
