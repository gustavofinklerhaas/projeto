import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/entities/shopping_item_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/get_all_categories.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/add_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/remove_category.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/domain/usecases/update_category.dart';

/// CategoriesState
///
/// Representa os possíveis estados da lista de categorias.
class CategoriesState {
  final List<ShoppingItemCategory> categories;
  final bool isLoading;
  final String? error;

  CategoriesState({
    required this.categories,
    required this.isLoading,
    this.error,
  });

  CategoriesState copyWith({
    List<ShoppingItemCategory>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// CategoriesController
///
/// Gerencia o estado reativo de categorias.
/// Utiliza ValueNotifier para notificações de mudança.
class CategoriesController {
  final GetAllCategories _getAllCategories;
  final AddCategory _addCategory;
  final RemoveCategory _removeCategory;
  final UpdateCategory _updateCategory;

  late ValueNotifier<CategoriesState> state;

  CategoriesController({
    required GetAllCategories getAllCategories,
    required AddCategory addCategory,
    required RemoveCategory removeCategory,
    required UpdateCategory updateCategory,
  })  : _getAllCategories = getAllCategories,
        _addCategory = addCategory,
        _removeCategory = removeCategory,
        _updateCategory = updateCategory {
    state = ValueNotifier(
      CategoriesState(
        categories: [],
        isLoading: false,
      ),
    );
  }

  /// Carrega todas as categorias
  Future<void> loadCategories() async {
    try {
      state.value = state.value.copyWith(isLoading: true, error: null);

      final categories = await _getAllCategories();
      state.value = state.value.copyWith(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: 'Erro ao carregar categorias: $e',
      );
    }
  }

  /// Adiciona uma nova categoria
  Future<void> addCategory(ShoppingItemCategory category) async {
    try {
      await _addCategory(category);
      await loadCategories();
    } catch (e) {
      state.value = state.value.copyWith(
        error: 'Erro ao adicionar categoria: $e',
      );
    }
  }

  /// Remove uma categoria
  Future<void> removeCategory(String id) async {
    try {
      await _removeCategory(id);
      await loadCategories();
    } catch (e) {
      state.value = state.value.copyWith(
        error: 'Erro ao remover categoria: $e',
      );
    }
  }

  /// Atualiza uma categoria
  Future<void> updateCategory(ShoppingItemCategory category) async {
    try {
      await _updateCategory(category);
      await loadCategories();
    } catch (e) {
      state.value = state.value.copyWith(
        error: 'Erro ao atualizar categoria: $e',
      );
    }
  }

  /// Libera recursos do controller
  void dispose() {
    state.dispose();
  }
}
