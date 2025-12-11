import 'package:flutter_application_1/src/features/shopping_item_category/domain/entities/shopping_item_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/repositories/categories_repository.dart';

/// GetAllCategories
///
/// UseCase: Recupera todas as categorias armazenadas.
class GetAllCategories {
  final CategoriesRepository _repository;

  GetAllCategories(this._repository);

  Future<List<ShoppingItemCategory>> call() {
    return _repository.getAllCategories();
  }
}
