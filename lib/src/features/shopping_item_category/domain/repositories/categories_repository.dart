import 'package:flutter_application_1/src/features/shopping_item_category/domain/entities/shopping_item_category.dart';

/// CategoriesRepository (Abstract)
///
/// Contrato/interface para operações com categorias.
/// Separa a lógica de negócio do acesso a dados.
abstract class CategoriesRepository {
  /// Obtém todas as categorias
  Future<List<ShoppingItemCategory>> getAllCategories();

  /// Adiciona uma nova categoria
  Future<void> addCategory(ShoppingItemCategory category);

  /// Remove uma categoria pelo ID
  Future<void> removeCategory(String id);

  /// Atualiza uma categoria existente
  Future<void> updateCategory(ShoppingItemCategory category);
}
