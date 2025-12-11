import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/repositories/shopping_list_repository.dart';

/// AddItem UseCase
/// 
/// Responsável por adicionar um novo item à lista de compras.
/// Segue o padrão de Clean Architecture:
/// - Encapsula a lógica de adição de item
/// - Pode validar dados antes de adicionar
/// - Permite testes isolados
/// 
/// Padrão: O método [call] permite chamar a classe como função
class AddItem {
  final ShoppingListRepository _repository;

  /// Construtor que recebe a instância do repositório
  /// 
  /// Segue injeção de dependência
  AddItem(this._repository);

  /// Executa o caso de uso
  /// 
  /// Parâmetros:
  ///   - item: O [ShoppingItem] a ser adicionado
  /// 
  /// Retorna:
  ///   Uma Future que completa quando o item é adicionado
  /// 
  /// Uso:
  ///   final usecase = AddItem(repository);
  ///   await usecase(shoppingItem);
  Future<void> call(ShoppingItem item) {
    return _repository.addItem(item);
  }
}
