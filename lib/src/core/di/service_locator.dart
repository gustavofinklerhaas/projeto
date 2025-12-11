import 'package:get_it/get_it.dart';
import '../domain/repositories/repositories.dart';
import '../data/repositories/shopping_list_repository_impl.dart';
import '../data/preferences_service.dart';

/// Configuração de Injeção de Dependência (Service Locator)
/// Permite acesso global às dependências sem passar por múltiplas camadas
class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  /// Inicializa todas as dependências do aplicativo
  static Future<void> setup() async {
    // 1. DATA SOURCES
    final preferencesService = PreferencesService();
    await preferencesService.init();
    _getIt.registerSingleton<PreferencesService>(preferencesService);

    // RemoteDataSource será registrado quando API estiver disponível
    // _getIt.registerSingleton<RemoteDataSource>(RemoteDataSourceImpl());

    // 2. REPOSITORIES
    _getIt.registerSingleton<ShoppingListRepository>(
      ShoppingListRepositoryImpl(
        localDataSource: _getIt<PreferencesService>(),
        // remoteDataSource: _getIt<RemoteDataSource>(), // Descomente quando API estiver pronta
      ),
    );

    _getIt.registerSingleton<ShoppingItemRepository>(
      ShoppingItemRepositoryImpl(
        localDataSource: _getIt<PreferencesService>(),
      ),
    );

    _getIt.registerSingleton<CategoryRepository>(
      CategoryRepositoryImpl(
        localDataSource: _getIt<PreferencesService>(),
      ),
    );

    // 3. LOAD DEFAULT DATA
    await _getIt<CategoryRepository>().loadDefaultCategories();
  }

  /// Obtém instância de um tipo registrado
  static T get<T extends Object>() => _getIt<T>();

  /// Limpa todas as dependências (útil para testes)
  static void reset() => _getIt.reset();
}
