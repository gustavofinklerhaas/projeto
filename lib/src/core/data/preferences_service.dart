import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Serviço para gerenciar preferências locais do usuário
class PreferencesService {
  static const String _keyTermsAccepted = 'terms_accepted';
  static const String _keyConsentGiven = 'consent_given';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyTermsReadCount = 'terms_read_count';
  static const String _keyTermsVersion = 'terms_version';
  static const String _keyTermsRefusedCount = 'terms_refused_count';
  static const String _keyShoppingLists = 'shopping_lists';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyCategories = 'shopping_categories';

  late SharedPreferences _prefs;

  /// Inicializa o serviço
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Verifica se os termos já foram aceitos
  Future<bool> areTermsAccepted() async {
    return _prefs.getBool(_keyTermsAccepted) ?? false;
  }

  /// Verifica se o consentimento foi dado
  Future<bool> isConsentGiven() async {
    return _prefs.getBool(_keyConsentGiven) ?? false;
  }

  /// Verifica se o onboarding foi completado
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Obtém a contagem de vezes que os termos foram lidos
  Future<int> getTermsReadCount() async {
    return _prefs.getInt(_keyTermsReadCount) ?? 0;
  }

  /// Incrementa a contagem de leitura dos termos
  Future<void> incrementTermsReadCount() async {
    int currentCount = await getTermsReadCount();
    await _prefs.setInt(_keyTermsReadCount, currentCount + 1);
  }

  /// Obtém a versão dos termos aceita
  Future<String?> getAcceptedTermsVersion() async {
    return _prefs.getString(_keyTermsVersion);
  }

  /// Define os termos como aceitos
  Future<void> setTermsAccepted(String termsVersion) async {
    await _prefs.setBool(_keyTermsAccepted, true);
    await _prefs.setString(_keyTermsVersion, termsVersion);
    await _prefs.setInt(_keyTermsRefusedCount, 0);
  }

  /// Define o consentimento como dado
  Future<void> setConsentGiven() async {
    await _prefs.setBool(_keyConsentGiven, true);
  }

  /// Define o onboarding como completo
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// Recusa os termos
  Future<void> refuseTerms() async {
    await _prefs.setBool(_keyTermsAccepted, false);
    int refusedCount = _prefs.getInt(_keyTermsRefusedCount) ?? 0;
    await _prefs.setInt(_keyTermsRefusedCount, refusedCount + 1);
  }

  /// Obtém a contagem de recusas dos termos
  Future<int> getTermsRefusedCount() async {
    return _prefs.getInt(_keyTermsRefusedCount) ?? 0;
  }

  /// Limpa todos os dados (para teste)
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Reseta os dados de termos mantendo outras configurações
  Future<void> resetTermsAcceptance() async {
    await _prefs.remove(_keyTermsAccepted);
    await _prefs.remove(_keyTermsVersion);
    await _prefs.remove(_keyTermsReadCount);
  }

  /// Obtém todas as listas de compras
  Future<List<Map<String, dynamic>>> getShoppingLists() async {
    try {
      final listsJson = _prefs.getString(_keyShoppingLists);
      if (listsJson == null) return [];
      
      final List<dynamic> decoded = jsonDecode(listsJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Cria uma nova lista de compras
  Future<void> createShoppingList(String name) async {
    try {
      final lists = await getShoppingLists();
      lists.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'items': [],
        'createdAt': DateTime.now().toIso8601String(),
        'completed': false,
      });
      await _prefs.setString(_keyShoppingLists, jsonEncode(lists));
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza uma lista de compras
  Future<void> updateShoppingList(String id, Map<String, dynamic> listData) async {
    final lists = await getShoppingLists();
    final index = lists.indexWhere((l) => l['id'] == id);
    if (index != -1) {
      lists[index] = {...lists[index], ...listData};
      await _prefs.setString(_keyShoppingLists, jsonEncode(lists));
    }
  }

  /// Deleta uma lista de compras
  Future<void> deleteShoppingList(String id) async {
    final lists = await getShoppingLists();
    lists.removeWhere((l) => l['id'] == id);
    await _prefs.setString(_keyShoppingLists, jsonEncode(lists));
  }

  /// Obtém uma lista específica
  Future<Map<String, dynamic>?> getShoppingList(String id) async {
    final lists = await getShoppingLists();
    try {
      return lists.firstWhere((l) => l['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtém o modo escuro
  Future<bool> isDarkMode() async {
    return _prefs.getBool(_keyDarkMode) ?? false;
  }

  /// Define o modo escuro
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_keyDarkMode, isDark);
  }

  /// Obtém todas as categorias de compras
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final categoriesJson = _prefs.getString(_keyCategories);
      if (categoriesJson == null) {
        // Cria categorias padrão se não existirem
        final defaultCategories = [
          {'id': '1', 'name': 'Frutas e Verduras', 'colorHex': 'FF66BB6A'},
          {'id': '2', 'name': 'Laticínios', 'colorHex': 'FFAB47BC'},
          {'id': '3', 'name': 'Carnes e Peixes', 'colorHex': 'FFEF5350'},
          {'id': '4', 'name': 'Bebidas', 'colorHex': 'FF29B6F6'},
          {'id': '5', 'name': 'Grãos e Cereais', 'colorHex': 'FFFFA726'},
          {'id': '6', 'name': 'Higiene Pessoal', 'colorHex': 'FFEC407A'},
          {'id': '7', 'name': 'Limpeza', 'colorHex': 'FF78909C'},
          {'id': '8', 'name': 'Outros', 'colorHex': 'FFBDBDBD'},
        ];
        await _prefs.setString(_keyCategories, jsonEncode(defaultCategories));
        return defaultCategories;
      }
      
      final List<dynamic> decoded = jsonDecode(categoriesJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Cria uma nova categoria
  Future<void> createCategory(String name, String colorHex) async {
    try {
      final categories = await getCategories();
      categories.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'colorHex': colorHex,
      });
      await _prefs.setString(_keyCategories, jsonEncode(categories));
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza uma categoria
  Future<void> updateCategory(String id, Map<String, dynamic> categoryData) async {
    final categories = await getCategories();
    final index = categories.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      categories[index] = {...categories[index], ...categoryData};
      await _prefs.setString(_keyCategories, jsonEncode(categories));
    }
  }

  /// Deleta uma categoria
  Future<void> deleteCategory(String id) async {
    final categories = await getCategories();
    categories.removeWhere((c) => c['id'] == id);
    await _prefs.setString(_keyCategories, jsonEncode(categories));
  }

  /// Obtém uma categoria específica
  Future<Map<String, dynamic>?> getCategory(String id) async {
    final categories = await getCategories();
    try {
      return categories.firstWhere((c) => c['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Revoga o consentimento do usuário
  Future<void> revokeConsent() async {
    await _prefs.setBool(_keyConsentGiven, false);
    await _prefs.setBool(_keyTermsAccepted, false);
  }

  /// Verifica se a versão dos termos foi atualizada
  Future<bool> isTermsVersionOutdated(String currentVersion) async {
    final acceptedVersion = await getAcceptedTermsVersion();
    if (acceptedVersion == null) return true;
    return acceptedVersion != currentVersion;
  }}