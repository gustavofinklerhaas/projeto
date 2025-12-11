import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/src/features/home/presentation/controller/home_state.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/get_all_items.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/add_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/remove_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/update_item.dart';
import 'package:flutter_application_1/src/shared/enums/sort_mode.dart';
import 'package:uuid/uuid.dart';

/// HomeController
/// 
/// Controller responsável por gerenciar a lógica de negócios da tela Home.
/// Segue os princípios de Clean Architecture:
/// - Usa ValueNotifier para reatividade
/// - Depende de UseCases, não de repositories
/// - Separa lógica de UI
/// 
/// Padrão: ValueNotifier com HomeState permite que a UI observe mudanças
class HomeController {
  final GetAllItems _getAllItems;
  final AddItem _addItem;
  final RemoveItem _removeItem;
  final UpdateItem _updateItem;

  /// ValueNotifier que mantém o estado
  /// 
  /// A UI deve observar este notifier com ValueListenableBuilder
  final ValueNotifier<HomeState> state = ValueNotifier(HomeState.initial());

  /// Construtor que recebe os usecases
  /// 
  /// Segue injeção de dependência
  HomeController({
    required GetAllItems getAllItems,
    required AddItem addItem,
    required RemoveItem removeItem,
    required UpdateItem updateItem,
  })  : _getAllItems = getAllItems,
        _addItem = addItem,
        _removeItem = removeItem,
        _updateItem = updateItem;

  /// Carrega todos os itens da lista de compras
  /// 
  /// Atualiza o state com loading -> loaded
  Future<void> loadItems() async {
    try {
      state.value = HomeState.loading();
      final items = await _getAllItems();
      state.value = HomeState.loaded(items);
    } catch (e) {
      // Em caso de erro, mantém o estado anterior ou retorna vazio
      state.value = HomeState.loaded([]);
    }
  }

  /// Adiciona um novo item à lista
  /// 
  /// Parâmetros:
  ///   - title: Título/nome do item
  ///   - quantity: Quantidade do item
  ///   - categoryId: ID da categoria (opcional)
  /// 
  /// Processo:
  /// 1. Cria um novo ShoppingItem com ID único
  /// 2. Executa o usecase
  /// 3. Recarrega a lista
  Future<void> addItem(String title, int quantity, {String? categoryId}) async {
    try {
      if (title.isEmpty || quantity <= 0) {
        return;
      }

      final newItem = ShoppingItem(
        id: const Uuid().v4(),
        title: title,
        quantity: quantity,
        isDone: false,
        categoryId: categoryId,
      );

      await _addItem(newItem);
      await loadItems();
    } catch (e) {
      // Log error or show error message
    }
  }

  /// Remove um item da lista
  /// 
  /// Parâmetros:
  ///   - id: ID do item a remover
  /// 
  /// Recarrega a lista após remoção
  Future<void> removeItem(String id) async {
    try {
      await _removeItem(id);
      await loadItems();
    } catch (e) {
      // Log error or show error message
    }
  }

  /// Marca um item como concluído ou não
  /// 
  /// Parâmetros:
  ///   - id: ID do item
  /// 
  /// Alterna o status isDone do item
  Future<void> toggleDone(String id) async {
    try {
      final currentItems = state.value.items;
      final itemToUpdate = currentItems.firstWhere((item) => item.id == id);
      final updatedItem = itemToUpdate.copyWith(isDone: !itemToUpdate.isDone);
      await _updateItem(updatedItem);
      await loadItems();
    } catch (e) {
      // Log error or show error message
    }
  }

  /// Descarta o controller e libera recursos
  /// 
  /// IMPORTANTE: Chamar este método em dispose() da Widget
  void dispose() {
    state.dispose();
  }

  /// Aplica ordenação aos itens com base no modo selecionado
  /// 
  /// Parâmetros:
  ///   - mode: Modo de ordenação (SortMode enum)
  /// 
  /// Modos suportados:
  ///   - nameAZ: Alfabético A→Z
  ///   - nameZA: Alfabético Z→A
  ///   - category: Por categoria
  ///   - doneAtEnd: Itens concluídos ao final
  ///   - createdDate: Por data de criação
  void sortItems(SortMode mode) {
    try {
      final currentItems = List<ShoppingItem>.from(state.value.items);

      switch (mode) {
        case SortMode.nameAZ:
          currentItems.sort((a, b) => a.title.compareTo(b.title));
          break;
        case SortMode.nameZA:
          currentItems.sort((a, b) => b.title.compareTo(a.title));
          break;
        case SortMode.category:
          currentItems.sort((a, b) {
            final catA = a.categoryId ?? '';
            final catB = b.categoryId ?? '';
            return catA.compareTo(catB);
          });
          break;
        case SortMode.doneAtEnd:
          currentItems.sort((a, b) {
            if (a.isDone == b.isDone) return 0;
            return a.isDone ? 1 : -1;
          });
          break;
        case SortMode.createdDate:
          currentItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
      }

      state.value = HomeState.loaded(currentItems);
    } catch (e) {
      // Log error or show error message
    }
  }
}
