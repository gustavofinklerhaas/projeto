import 'package:flutter_application_1/src/features/shopping_item_category/domain/repositories/categories_repository.dart';

/// RemoveCategory
///
/// UseCase: Remove uma categoria pelo ID.
class RemoveCategory {
  final CategoriesRepository _repository;

  RemoveCategory(this._repository);

  Future<void> call(String id) {
    return _repository.removeCategory(id);
  }
}
