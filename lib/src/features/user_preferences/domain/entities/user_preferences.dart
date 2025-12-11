/// UserPreferences Entity
/// 
/// Entidade que representa preferências do usuário da aplicação.
/// Segue os princípios de Clean Architecture:
/// - Imutável (final fields)
/// - Independente de camadas inferiores
/// - Sem dependências de DTO ou Model
/// - Contém apenas a lógica de negócios essencial
class UserPreferences {
  final String themeMode; // "light", "dark", "system"
  final String sortMode; // "name", "date", "quantity"
  final bool notificationsEnabled;

  /// Construtor da entidade UserPreferences
  /// 
  /// Parâmetros:
  ///   - themeMode: Modo de tema ("light", "dark", "system")
  ///   - sortMode: Modo de ordenação ("name", "date", "quantity")
  ///   - notificationsEnabled: Se notificações estão ativadas
  const UserPreferences({
    required this.themeMode,
    required this.sortMode,
    required this.notificationsEnabled,
  });

  /// Cria uma cópia das preferências com campos opcionais modificados
  /// 
  /// Útil para atualizar apenas alguns campos sem criar uma nova instância
  /// do zero. Segue o padrão de imutabilidade funcional.
  UserPreferences copyWith({
    String? themeMode,
    String? sortMode,
    bool? notificationsEnabled,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      sortMode: sortMode ?? this.sortMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferences &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          sortMode == other.sortMode &&
          notificationsEnabled == other.notificationsEnabled;

  @override
  int get hashCode =>
      themeMode.hashCode ^ sortMode.hashCode ^ notificationsEnabled.hashCode;

  @override
  String toString() =>
      'UserPreferences(themeMode: $themeMode, sortMode: $sortMode, notificationsEnabled: $notificationsEnabled)';
}
