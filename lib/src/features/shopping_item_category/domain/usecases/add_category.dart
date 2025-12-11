import 'package:flutter_application_1/src/features/shopping_item_category/domain/entities/shopping_item_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/repositories/categories_repository.dart';

/// AddCategory
///
/// UseCase: Adiciona uma nova categoria.
class AddCategory {
  final CategoriesRepository _repository;

  AddCategory(this._repository);

  Future<void> call(ShoppingItemCategory category) {
    return _repository.addCategory(category);
  }
}
