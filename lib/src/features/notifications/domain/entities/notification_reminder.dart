/// NotificationReminder Entity
/// 
/// Entidade que representa um lembrete de notificação.
/// Segue os princípios de Clean Architecture:
/// - Imutável (final fields)
/// - Independente de camadas inferiores
/// - Contém apenas lógica de negócios essencial
class NotificationReminder {
  final String id;
  final int hour;
  final int minute;
  final bool isEnabled;
  final String title;
  final String body;

  /// Construtor da entidade NotificationReminder
  /// 
  /// Parâmetros:
  ///   - id: Identificador único do lembrete
  ///   - hour: Hora da notificação (0-23)
  ///   - minute: Minuto da notificação (0-59)
  ///   - isEnabled: Se o lembrete está ativado
  ///   - title: Título da notificação
  ///   - body: Corpo/mensagem da notificação
  NotificationReminder({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isEnabled,
    required this.title,
    required this.body,
  });

  /// Cria uma cópia do lembrete com campos opcionais modificados
  NotificationReminder copyWith({
    String? id,
    int? hour,
    int? minute,
    bool? isEnabled,
    String? title,
    String? body,
  }) {
    return NotificationReminder(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationReminder &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hour == other.hour &&
          minute == other.minute &&
          isEnabled == other.isEnabled &&
          title == other.title &&
          body == other.body;

  @override
  int get hashCode =>
      id.hashCode ^
      hour.hashCode ^
      minute.hashCode ^
      isEnabled.hashCode ^
      title.hashCode ^
      body.hashCode;

  @override
  String toString() =>
      'NotificationReminder(id: $id, hour: $hour:${minute.toString().padLeft(2, '0')}, isEnabled: $isEnabled, title: $title, body: $body)';
}
