import 'package:flutter_application_1/src/features/user_preferences/domain/entities/user_preferences.dart';

/// UserPreferencesRepository (Abstract)
///
/// Contrato para operações com preferências do usuário.
abstract class UserPreferencesRepository {
  /// Obtém as preferências do usuário (ou padrões se não existirem)
  Future<UserPreferences> getPreferences();

  /// Salva as preferências do usuário
  Future<void> savePreferences(UserPreferences preferences);
}
