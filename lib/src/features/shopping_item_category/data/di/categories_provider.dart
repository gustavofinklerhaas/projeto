import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/data/datasources/categories_local_data_source.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/data/repositories/categories_repository_impl.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/repositories/categories_repository.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/get_all_categories.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/add_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/remove_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/update_category.dart';

/// CategoriesProvider
///
/// Provedor de Injeção de Dependência (DI) para a feature de categorias.
/// Centraliza a criação e configuração de todas as dependências.
abstract class CategoriesProvider {
  /// Fornece a instância do repository de categorias
  static CategoriesRepository provideRepository(SharedPreferences prefs) {
    final dataSource = CategoriesLocalDataSourceImpl(prefs);
    return CategoriesRepositoryImpl(dataSource);
  }

  /// Fornece os UseCases para categorias
  static ({
    GetAllCategories getAllCategories,
    AddCategory addCategory,
    RemoveCategory removeCategory,
    UpdateCategory updateCategory,
  }) provideUseCases(CategoriesRepository repository) {
    return (
      getAllCategories: GetAllCategories(repository),
      addCategory: AddCategory(repository),
      removeCategory: RemoveCategory(repository),
      updateCategory: UpdateCategory(repository),
    );
  }
}
