import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/user_preferences/domain/repositories/user_preferences_repository.dart';

/// ThemeController
///
/// Gerencia o tema da aplicação de forma reativa.
/// Implementa padrão Singleton para garantir instância única
class ThemeController {
  static ThemeController? _instance;
  
  final UserPreferencesRepository _repository;
  
  late ValueNotifier<String> themeMode;
  late ValueNotifier<bool> isDarkMode;

  ThemeController._({required UserPreferencesRepository repository})
      : _repository = repository {
    themeMode = ValueNotifier('system');
    isDarkMode = ValueNotifier(false);
  }

  /// Factory constructor que retorna instância Singleton
  factory ThemeController({required UserPreferencesRepository repository}) {
    _instance ??= ThemeController._(repository: repository);
    return _instance!;
  }

  /// Retorna a instância existente (usado internamente)
  static ThemeController? get instance => _instance;

  /// Carrega as preferências salvas
  Future<void> loadPreferences() async {
    try {
      final prefs = await _repository.getPreferences();
      themeMode.value = prefs.themeMode;
      _updateDarkMode(prefs.themeMode);
    } catch (e) {
      themeMode.value = 'system';
    }
  }

  /// Alterna o tema entre light, dark e system
  Future<void> toggleTheme() async {
    final newMode = _getNextThemeMode(themeMode.value);
    themeMode.value = newMode;
    _updateDarkMode(newMode);
    
    final prefs = await _repository.getPreferences();
    final updated = prefs.copyWith(themeMode: newMode);
    await _repository.savePreferences(updated);
  }

  /// Define o tema explicitamente
  Future<void> setTheme(String mode) async {
    themeMode.value = mode;
    _updateDarkMode(mode);
    
    final prefs = await _repository.getPreferences();
    final updated = prefs.copyWith(themeMode: mode);
    await _repository.savePreferences(updated);
  }

  /// Atualiza isDarkMode baseado no modo de tema
  void _updateDarkMode(String mode) {
    switch (mode) {
      case 'dark':
        isDarkMode.value = true;
        break;
      case 'light':
        isDarkMode.value = false;
        break;
      case 'system':
      default:
        // Usa o tema do sistema (será tratado no app)
        isDarkMode.value = false;
        break;
    }
  }

  /// Retorna o próximo modo de tema em sequência
  String _getNextThemeMode(String currentMode) {
    switch (currentMode) {
      case 'light':
        return 'dark';
      case 'dark':
        return 'system';
      case 'system':
      default:
        return 'light';
    }
  }

  /// Libera recursos
  void dispose() {
    themeMode.dispose();
    isDarkMode.dispose();
  }
}
