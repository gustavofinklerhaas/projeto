# 📋 FASE 3 - DAILY GOALS (Metas Diárias)

## 🎯 Objetivo

Implementar um sistema de **metas diárias** com **notificações inteligentes** para ajudar o usuário a controlar seus gastos.

---

## ✨ 2 Features Principais

### **Feature 1: Criar e Acompanhar Metas Diárias** 📊

Permite que o usuário crie uma meta de gasto para o dia.

**O que pode fazer:**
- Definir limite de gasto (ex: R$100)
- Visualizar o progresso em tempo real
- Ver quanto ainda pode gastar
- Acompanhar o percentual gasto

**Componentes:**
- `DailyGoal` Entity - Representa a meta do dia
- `DailyGoalCard` Widget - Interface visual mostrando a meta

---

### **Feature 2: Notificações Inteligentes com IA** 🤖

Gera mensagens personalizadas baseado no progresso do gasto.

**Mensagens Geradas:**
- **0-30%**: "🎯 Você tem bastante margem! Continue assim!"
- **30-60%**: "💰 Tá subindo, mas ainda tem espaço."
- **60-80%**: "⚠️ Tá próximo! Cuidado com os próximos gastos."
- **80-100%**: "🚨 Tá no limite! Apenas R$ XX restantes."
- **100%+**: "❌ Estourou a meta! Você já passou do limite."

**Componentes:**
- `GoalMessageService` - Service que gera as mensagens (IA)

---

## 📁 Estrutura de Arquivos

```
lib/src/features/daily_goals/
├── entities/
│   └── daily_goal.dart              (Entity principal)
├── services/
│   └── goal_message_service.dart    (IA - Mensagens inteligentes)
└── widgets/
    └── daily_goal_card.dart         (UI - Card do widget)

test/
└── daily_goals_test.dart            (22 testes)
```

---

## 🏗️ Componentes Criados

### 1. **DailyGoal Entity** 📝
```dart
class DailyGoal {
  final String id;
  final DateTime date;
  final double goalLimit;        // Meta (ex: 100.0)
  final double currentSpent;     // Gasto atual (ex: 45.0)
  
  // Métodos úteis
  double getProgress()           // 0.0 a 1.0
  bool isGoalReached()           // Meta atingida?
  double getRemainingBudget()    // Quanto ainda pode gastar?
}
```

**Arquivo**: `lib/src/features/daily_goals/entities/daily_goal.dart`

---

### 2. **GoalMessageService** 🤖 (IA)
```dart
class GoalMessageService {
  String generateMessage(double progress)
  String generateRecommendation(double progress, double remaining)
  int getProgressColorIndex(double progress)
  String getProgressEmoji(double progress)
}
```

Gera mensagens inteligentes baseado no progresso (0.0-1.0).

**Arquivo**: `lib/src/features/daily_goals/services/goal_message_service.dart`

---

### 3. **DailyGoalCard Widget** 🎨
```dart
class DailyGoalCard extends StatelessWidget {
  final DailyGoal goal;
  // Mostra:
  // - Meta | Gasto | Restante
  // - Barra de progresso visual
  // - Mensagem inteligente
  // - Cores dinâmicas (verde → vermelho)
}
```

**Arquivo**: `lib/src/features/daily_goals/widgets/daily_goal_card.dart`

---

## 🧪 Testes

**22 testes implementados** (100% de sucesso)

### Testes do DailyGoal Entity (10 testes)
- ✓ Criar meta com valores iniciais
- ✓ Calcular progresso
- ✓ Detectar meta atingida
- ✓ Calcular percentual
- ✓ Calcular orçamento restante
- ✓ Atualizar gasto
- ✓ Serializar/Desserializar JSON
- E mais...

### Testes do GoalMessageService (9 testes)
- ✓ Gerar mensagem por faixa de progresso
- ✓ Gerar recomendação
- ✓ Retornar cor baseada em progresso
- ✓ Retornar emoji correto
- E mais...

### Testes de Integração (3 testes)
- ✓ DailyGoal + GoalMessageService funcionando junto
- ✓ Fluxo completo de meta do dia
- ✓ Detectar quando meta foi excedida

**Executar testes:**
```bash
flutter test test/daily_goals_test.dart
```

---

## 💡 Exemplos de Uso

### Criar uma meta

```dart
final goal = DailyGoal(
  date: DateTime.now(),
  goalLimit: 100.0,  // Meta: R$100
  currentSpent: 0.0,
  description: 'Meta do dia',
);
```

### Acompanhar progresso

```dart
final progress = goal.getProgress();          // 0.5 (50%)
final percentage = goal.getProgressPercentage(); // 50.0
final remaining = goal.getRemainingBudget();  // 50.0
```

### Atualizar gasto

```dart
final updatedGoal = goal.updateSpent(50.0);
```

### Gerar mensagem inteligente

```dart
final messageService = GoalMessageService();
final message = messageService.generateMessage(goal.getProgress());
// "💰 Tá subindo, mas ainda tem espaço."
```

### Usar o Widget

```dart
DailyGoalCard(
  goal: goal,
  onTap: () => print('Tapped!'),
  onUpdateSpent: (newAmount) => print('Novo gasto: $newAmount'),
)
```

---

## 🎨 Recursos Visuais

### Cores Dinâmicas
- **Verde** (0-50%): "Você tem bastante margem"
- **Amarelo** (50-75%): "Tá subindo"
- **Laranja** (75-100%): "Tá no limite"
- **Vermelho** (100%+): "Estourou"

### Emojis
- ✅ Baixo progresso
- ⚠️ Progresso médio
- 🚨 Progresso alto
- ❌ Meta excedida

---

## 🔗 Arquivos no GitHub

### Feature 1: Daily Goal Entity & Widget
- Entity: `lib/src/features/daily_goals/entities/daily_goal.dart`
- Widget: `lib/src/features/daily_goals/widgets/daily_goal_card.dart`

### Feature 2: Intelligent Messages (IA)
- Service: `lib/src/features/daily_goals/services/goal_message_service.dart`

### Testes
- Tests: `test/daily_goals_test.dart` (22 testes)

---

## ✅ Status

**✅ FASE 3 COMPLETA**

- ✓ 2 Features implementadas
- ✓ Entity com lógica de negócio
- ✓ Service com IA gerando mensagens
- ✓ Widget visual completo
- ✓ 22 testes passando (100%)
- ✓ Documentação clara

---

## 📚 Padrões Utilizados

- **Entity Pattern**: DailyGoal como entity do domínio
- **Service Pattern**: GoalMessageService com lógica de IA
- **Widget Pattern**: DailyGoalCard com UI reativa
- **Test-Driven Development**: 22 testes cobrindo todos os cenários

---

**Desenvolvido com simplicidade, testado com rigor, documentado com clareza.** 🚀
