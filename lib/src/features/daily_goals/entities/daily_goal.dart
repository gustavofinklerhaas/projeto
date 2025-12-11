import 'package:uuid/uuid.dart';

/// Entity: Meta Diária (Daily Goal)
class DailyGoal {
  final String id;
  final DateTime date;
  final double goalLimit;
  final double currentSpent;
  final String description;

  DailyGoal({
    String? id,
    required this.date,
    required this.goalLimit,
    this.currentSpent = 0.0,
    this.description = 'Meta do dia',
  }) : id = id ?? const Uuid().v4();

  /// Retorna progresso de 0.0 a 1.0
  double getProgress() {
    if (goalLimit <= 0) return 0.0;
    return (currentSpent / goalLimit).clamp(0.0, 1.0);
  }

  /// Verifica se meta foi atingida
  bool isGoalReached() => currentSpent >= goalLimit;

  /// Retorna percentual (0-100)
  double getProgressPercentage() => getProgress() * 100;

  /// Retorna quanto ainda pode gastar
  double getRemainingBudget() {
    final remaining = goalLimit - currentSpent;
    return remaining > 0 ? remaining : 0.0;
  }

  /// Atualiza o gasto atual
  DailyGoal updateSpent(double newSpent) {
    return DailyGoal(
      id: id,
      date: date,
      goalLimit: goalLimit,
      currentSpent: newSpent,
      description: description,
    );
  }

  /// Serializa para JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'goalLimit': goalLimit,
        'currentSpent': currentSpent,
        'description': description,
      };

  /// Desserializa de JSON
  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      goalLimit: (json['goalLimit'] as num).toDouble(),
      currentSpent: (json['currentSpent'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? 'Meta do dia',
    );
  }

  @override
  String toString() =>
      'DailyGoal(id: $id, date: $date, goalLimit: $goalLimit, currentSpent: $currentSpent)';
}
