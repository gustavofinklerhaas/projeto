import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/src/features/daily_goals/entities/daily_goal.dart';
import 'package:shopping_list/src/features/daily_goals/services/goal_message_service.dart';

void main() {
  group('Daily Goals - Feature Tests', () {
    // ============ DAILY GOAL ENTITY TESTS ============
    group('DailyGoal Entity', () {
      test('deve criar DailyGoal com valores iniciais', () {
        // Arrange
        final today = DateTime.now();
        const goalLimit = 100.0;

        // Act
        final goal = DailyGoal(
          date: today,
          goalLimit: goalLimit,
        );

        // Assert
        expect(goal.id, isNotNull);
        expect(goal.date, equals(today));
        expect(goal.goalLimit, equals(goalLimit));
        expect(goal.currentSpent, equals(0.0));
      });

      test('deve calcular progresso corretamente', () {
        // Arrange
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 50.0,
        );

        // Act
        final progress = goal.getProgress();

        // Assert
        expect(progress, equals(0.5));
      });

      test('deve retornar progresso máximo 1.0 quando exceder limite', () {
        // Arrange
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 150.0,
        );

        // Act
        final progress = goal.getProgress();

        // Assert
        expect(progress, equals(1.0));
      });

      test('deve detectar quando meta foi atingida', () {
        // Arrange
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 100.0,
        );

        // Act
        final reached = goal.isGoalReached();

        // Assert
        expect(reached, isTrue);
      });

      test('deve detectar quando meta não foi atingida', () {
        // Arrange
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 50.0,
        );

        // Act
        final reached = goal.isGoalReached();

        // Assert
        expect(reached, isFalse);
      });

      test('deve calcular percentual de progresso', () {
        // Arrange
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 75.0,
        );

        // Act
        final percentage = goal.getProgressPercentage();

        // Assert
        expect(percentage, equals(75.0));
      });

      test('deve calcular orçamento restante', () {
        // Arrange
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 30.0,
        );

        // Act
        final remaining = goal.getRemainingBudget();

        // Assert
        expect(remaining, equals(70.0));
      });

      test('deve atualizar gasto atual', () {
        // Arrange
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 50.0,
        );

        // Act
        final updatedGoal = goal.updateSpent(75.0);

        // Assert
        expect(updatedGoal.currentSpent, equals(75.0));
        expect(updatedGoal.id, equals(goal.id));
      });

      test('deve serializar para JSON', () {
        // Arrange
        final goal = DailyGoal(
          id: '123',
          date: DateTime(2024, 1, 1),
          goalLimit: 100.0,
          currentSpent: 50.0,
          description: 'Meta de teste',
        );

        // Act
        final json = goal.toJson();

        // Assert
        expect(json['id'], equals('123'));
        expect(json['goalLimit'], equals(100.0));
        expect(json['currentSpent'], equals(50.0));
        expect(json['description'], equals('Meta de teste'));
      });

      test('deve desserializar de JSON', () {
        // Arrange
        final json = {
          'id': '123',
          'date': '2024-01-01T00:00:00.000Z',
          'goalLimit': 100.0,
          'currentSpent': 50.0,
          'description': 'Meta de teste',
        };

        // Act
        final goal = DailyGoal.fromJson(json);

        // Assert
        expect(goal.id, equals('123'));
        expect(goal.goalLimit, equals(100.0));
        expect(goal.currentSpent, equals(50.0));
      });
    });

    // ============ GOAL MESSAGE SERVICE TESTS ============
    group('GoalMessageService - IA Features', () {
      late GoalMessageService messageService;

      setUp(() {
        messageService = GoalMessageService();
      });

      test('deve gerar mensagem para progresso baixo (< 30%)', () {
        // Act
        final message = messageService.generateMessage(0.2);

        // Assert
        expect(message, contains('bastante margem'));
      });

      test('deve gerar mensagem para progresso médio (30-60%)', () {
        // Act
        final message = messageService.generateMessage(0.45);

        // Assert
        expect(message, contains('subindo'));
      });

      test('deve gerar mensagem para progresso alto (60-80%)', () {
        // Act
        final message = messageService.generateMessage(0.7);

        // Assert
        expect(message, contains('próximo'));
      });

      test('deve gerar mensagem para progresso crítico (80-100%)', () {
        // Act
        final message = messageService.generateMessage(0.9);

        // Assert
        expect(message, contains('limite'));
      });

      test('deve gerar mensagem para progresso excedido (> 100%)', () {
        // Act
        final message = messageService.generateMessage(1.2);

        // Assert
        expect(message, contains('Estourou'));
      });

      test('deve gerar recomendação para progresso baixo', () {
        // Act
        final recommendation = messageService.generateRecommendation(0.3, 70.0);

        // Assert
        expect(recommendation, contains('gastar'));
      });

      test('deve gerar recomendação para progresso alto', () {
        // Act
        final recommendation = messageService.generateRecommendation(0.9, 10.0);

        // Assert
        expect(recommendation, contains('parar'));
      });

      test('deve retornar índice de cor correto', () {
        // Act & Assert
        expect(messageService.getProgressColorIndex(0.3), equals(0)); // Verde
        expect(messageService.getProgressColorIndex(0.6), equals(1)); // Amarelo
        expect(messageService.getProgressColorIndex(0.85), equals(2)); // Laranja
        expect(messageService.getProgressColorIndex(1.1), equals(3)); // Vermelho
      });

      test('deve retornar emoji baseado no progresso', () {
        // Act & Assert
        expect(messageService.getProgressEmoji(0.3), equals('✅'));
        expect(messageService.getProgressEmoji(0.6), equals('⚠️'));
        expect(messageService.getProgressEmoji(0.85), equals('🚨'));
        expect(messageService.getProgressEmoji(1.1), equals('❌'));
      });
    });

    // ============ INTEGRATION TESTS ============
    group('Daily Goals - Integration Tests', () {
      test('deve integrar DailyGoal e GoalMessageService', () {
        // Arrange
        final messageService = GoalMessageService();
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 85.0,
        );

        // Act
        final progress = goal.getProgress();
        final message = messageService.generateMessage(progress);
        final emoji = messageService.getProgressEmoji(progress);

        // Assert
        expect(progress, equals(0.85));
        expect(message, contains('limite'));
        expect(emoji, equals('🚨'));
      });

      test('deve executar fluxo completo de meta do dia', () {
        // Arrange
        final messageService = GoalMessageService();
        final initialGoal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 150.0,
          currentSpent: 0.0,
        );

        // Act - Adicionar gasto
        final updatedGoal = initialGoal.updateSpent(50.0);
        final progress = updatedGoal.getProgress();
        final message = messageService.generateMessage(progress);
        final remaining = updatedGoal.getRemainingBudget();

        // Assert
        expect(progress, equals(50.0 / 150.0));
        expect(message, contains('subindo'));
        expect(remaining, equals(100.0));
        expect(updatedGoal.isGoalReached(), isFalse);
      });

      test('deve detectar quando meta foi excedida', () {
        // Arrange
        final messageService = GoalMessageService();
        final goal = DailyGoal(
          date: DateTime.now(),
          goalLimit: 100.0,
          currentSpent: 120.0,
        );

        // Act
        final message = messageService.generateMessage(goal.getProgress());

        // Assert
        expect(goal.isGoalReached(), isTrue);
        expect(goal.getProgress(), equals(1.0)); // Clampado a 1.0
        expect(message, contains('Estourou'));
      });
    });
  });
}
