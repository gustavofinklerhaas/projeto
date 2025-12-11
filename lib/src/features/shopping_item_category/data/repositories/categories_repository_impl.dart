import 'package:flutter_application_1/src/features/shopping_item_category/data/datasources/categories_local_data_source.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/data/models/shopping_item_category_dto.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/data/mappers/shopping_item_category_mapper.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/entities/shopping_item_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/repositories/categories_repository.dart';

/// CategoriesRepositoryImpl
///
/// Implementação concreta de [CategoriesRepository].
/// Responsável por operações CRUD de categorias.
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesLocalDataSource _localDataSource;

  CategoriesRepositoryImpl(this._localDataSource);

  @override
  Future<List<ShoppingItemCategory>> getAllCategories() async {
    try {
      final categoriesMaps = await _localDataSource.getAll();

      return categoriesMaps
          .map((map) => ShoppingItemCategoryDto.fromMap(map))
          .map((dto) => ShoppingItemCategoryMapper.toEntity(dto))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  @override
  Future<void> addCategory(ShoppingItemCategory category) async {
    try {
      final currentCategories = await _localDataSource.getAll();

      final dto = ShoppingItemCategoryMapper.toDto(category);
      currentCategories.add(dto.toMap());

      await _localDataSource.saveAll(currentCategories);
    } catch (e) {
      throw Exception('Erro ao adicionar categoria: $e');
    }
  }

  @override
  Future<void> removeCategory(String id) async {
    try {
      final currentCategories = await _localDataSource.getAll();

      final updatedCategories = currentCategories
          .where((category) => category['id'] != id)
          .toList();

      await _localDataSource.saveAll(updatedCategories);
    } catch (e) {
      throw Exception('Erro ao remover categoria: $e');
    }
  }

  @override
  Future<void> updateCategory(ShoppingItemCategory category) async {
    try {
      final currentCategories = await _localDataSource.getAll();

      final dto = ShoppingItemCategoryMapper.toDto(category);
      final dtoMap = dto.toMap();

      final categoryIndex =
          currentCategories.indexWhere((map) => map['id'] == category.id);

      if (categoryIndex != -1) {
        currentCategories[categoryIndex] = dtoMap;
      } else {
        currentCategories.add(dtoMap);
      }

      await _localDataSource.saveAll(currentCategories);
    } catch (e) {
      throw Exception('Erro ao atualizar categoria: $e');
    }
  }
}
