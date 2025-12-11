import 'package:flutter_application_1/src/features/shopping_list/domain/entities/shopping_item.dart';

/// HomeState
/// 
/// Representa o estado da tela Home.
/// Segue o padrão de Clean Architecture para gerenciamento de estado.
/// 
/// Estados possíveis:
/// - initial: Estado inicial
/// - loading: Carregando dados
/// - loaded: Dados carregados com sucesso
class HomeState {
  final bool isLoading;
  final List<ShoppingItem> items;

  /// Construtor privado
  const HomeState._({
    required this.isLoading,
    required this.items,
  });

  /// Estado inicial
  /// 
  /// Usado quando a tela é aberta pela primeira vez
  factory HomeState.initial() {
    return const HomeState._(
      isLoading: false,
      items: [],
    );
  }

  /// Estado carregando
  /// 
  /// Usado quando está buscando dados do repositório
  factory HomeState.loading() {
    return const HomeState._(
      isLoading: true,
      items: [],
    );
  }

  /// Estado carregado
  /// 
  /// Usado quando os dados foram carregados com sucesso
  /// 
  /// Parâmetros:
  ///   - items: Lista de itens carregados
  factory HomeState.loaded(List<ShoppingItem> items) {
    return HomeState._(
      isLoading: false,
      items: items,
    );
  }

  /// Cria uma cópia do estado com alguns campos atualizados
  HomeState copyWith({
    bool? isLoading,
    List<ShoppingItem>? items,
  }) {
    return HomeState._(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          items == other.items;

  @override
  int get hashCode => isLoading.hashCode ^ items.hashCode;

  @override
  String toString() =>
      'HomeState(isLoading: $isLoading, items: ${items.length})';
}
