import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/features/shopping_list/data/datasources/local_data_source.dart';
import 'package:flutter_application_1/src/features/shopping_list/data/repositories/shopping_list_repository_impl.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/repositories/shopping_list_repository.dart';

/// ShoppingListProvider
/// 
/// Container simples de injeção de dependência para a feature shopping_list.
/// Responsável por:
/// - Criar instâncias únicas das dependências
/// - Expor as dependências para a aplicação
/// - Manter o gerenciamento centralizado de DI
/// 
/// Segue os princípios de Clean Architecture:
/// - Centraliza a configuração de dependências
/// - Desacopla a criação de objetos da sua utilização
/// - Facilita testes e manutenção
/// 
/// Pode ser expandido com GetIt, Provider, Riverpod, etc. no futuro
class ShoppingListProvider {
  /// Obtém a instância do LocalDataSource
  /// 
  /// Parâmetros:
  ///   - preferences: Instância de SharedPreferences (injetada)
  /// 
  /// Retorna:
  ///   Uma instância de [LocalDataSource] (implementação LocalDataSourceImpl)
  static LocalDataSource provideLocalDataSource(
    SharedPreferences preferences,
  ) {
    return LocalDataSourceImpl(preferences);
  }

  /// Obtém a instância do ShoppingListRepository
  /// 
  /// Parâmetros:
  ///   - preferences: Instância de SharedPreferences (injetada)
  /// 
  /// Retorna:
  ///   Uma instância de [ShoppingListRepository] 
  ///   (implementação ShoppingListRepositoryImpl)
  /// 
  /// Exemplo de uso:
  ///   final repository = ShoppingListProvider.provideRepository(prefs);
  ///   final items = await repository.getAllItems();
  static ShoppingListRepository provideRepository(
    SharedPreferences preferences,
  ) {
    final localDataSource = provideLocalDataSource(preferences);
    return ShoppingListRepositoryImpl(localDataSource);
  }
}
