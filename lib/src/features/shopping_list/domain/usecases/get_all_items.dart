import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/repositories/shopping_list_repository.dart';

/// GetAllItems UseCase
/// 
/// Responsável por buscar todos os itens da lista de compras.
/// Segue o padrão de Clean Architecture:
/// - Separa a lógica de negócios da apresentação
/// - Pode ser testado de forma isolada
/// - Representa um caso de uso específico
/// 
/// Padrão: O método [call] permite chamar a classe como função
class GetAllItems {
  final ShoppingListRepository _repository;

  /// Construtor que recebe a instância do repositório
  /// 
  /// Segue injeção de dependência
  GetAllItems(this._repository);

  /// Executa o caso de uso
  /// 
  /// Retorna:
  ///   Uma Future contendo a lista de [ShoppingItem]
  /// 
  /// Uso:
  ///   final usecase = GetAllItems(repository);
  ///   final items = await usecase();
  Future<List<ShoppingItem>> call() {
    return _repository.getAllItems();
  }
}
