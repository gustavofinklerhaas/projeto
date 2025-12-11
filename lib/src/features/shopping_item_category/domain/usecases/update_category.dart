import 'package:flutter_application_1/src/features/shopping_item_category/domain/entities/shopping_item_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/repositories/categories_repository.dart';

/// UpdateCategory
///
/// UseCase: Atualiza uma categoria existente.
class UpdateCategory {
  final CategoriesRepository _repository;

  UpdateCategory(this._repository);

  Future<void> call(ShoppingItemCategory category) {
    return _repository.updateCategory(category);
  }
}
