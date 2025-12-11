/// UserPreferencesDto
/// 
/// DTO (Data Transfer Object) que representa preferências do usuário na camada de dados.
/// Segue os princípios de Clean Architecture:
/// - NÃO estende Entity (separação clara)
/// - Existe apenas na camada Data
/// - Responsável exclusivamente pela serialização/desserialização
/// - Espelha o formato de armazenamento (SharedPreferences/API)
class UserPreferencesDto {
  final String themeMode;
  final String sortMode;
  final bool notificationsEnabled;

  /// Construtor do DTO
  const UserPreferencesDto({
    required this.themeMode,
    required this.sortMode,
    required this.notificationsEnabled,
  });

  /// Factory constructor: Cria um DTO a partir de um Map
  /// 
  /// Usado para desserializar dados do SharedPreferences, banco de dados, API, etc.
  /// 
  /// Exemplo:
  ///   final data = {
  ///     'themeMode': 'dark',
  ///     'sortMode': 'name',
  ///     'notificationsEnabled': true
  ///   };
  ///   final dto = UserPreferencesDto.fromMap(data);
  factory UserPreferencesDto.fromMap(Map<String, dynamic> map) {
    return UserPreferencesDto(
      themeMode: map['themeMode'] as String? ?? 'system',
      sortMode: map['sortMode'] as String? ?? 'name',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
    );
  }

  /// Factory constructor: Cria um DTO com valores padrão
  factory UserPreferencesDto.defaults() {
    return const UserPreferencesDto(
      themeMode: 'system',
      sortMode: 'name',
      notificationsEnabled: true,
    );
  }

  /// Converte o DTO para um Map
  /// 
  /// Usado para serializar dados para o SharedPreferences, banco de dados, API, etc.
  /// 
  /// Retorna:
  ///   Um Map com String como chave e valores dinâmicos
  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode,
      'sortMode': sortMode,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  /// Cria uma cópia do DTO com campos opcionais modificados
  UserPreferencesDto copyWith({
    String? themeMode,
    String? sortMode,
    bool? notificationsEnabled,
  }) {
    return UserPreferencesDto(
      themeMode: themeMode ?? this.themeMode,
      sortMode: sortMode ?? this.sortMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesDto &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          sortMode == other.sortMode &&
          notificationsEnabled == other.notificationsEnabled;

  @override
  int get hashCode =>
      themeMode.hashCode ^ sortMode.hashCode ^ notificationsEnabled.hashCode;

  @override
  String toString() =>
      'UserPreferencesDto(themeMode: $themeMode, sortMode: $sortMode, notificationsEnabled: $notificationsEnabled)';
}
