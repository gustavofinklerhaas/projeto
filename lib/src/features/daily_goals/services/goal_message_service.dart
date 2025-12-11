/// Service: Gera mensagens inteligentes baseado no progresso da meta
class GoalMessageService {
  /// Gera mensagem personizada baseado no progresso (0.0 a 1.0)
  String generateMessage(double progress) {
    final percentage = progress * 100;

    if (percentage < 30) {
      return '🎯 Você tem bastante margem! Continue assim!';
    } else if (percentage < 60) {
      return '💰 Tá subindo, mas ainda tem espaço.';
    } else if (percentage < 80) {
      return '⚠️ Tá próximo! Cuidado com os próximos gastos.';
    } else if (percentage < 100) {
      return '🚨 Tá no limite! Apenas R\${{ remaining }} restantes.';
    } else {
      return '❌ Estourou a meta! Você já passou do limite.';
    }
  }

  /// Gera mensagem com recomendação de ação
  String generateRecommendation(double progress, double remaining) {
    if (progress < 0.5) {
      return 'Você pode gastar mais R\$ ${remaining.toStringAsFixed(2)}';
    } else if (progress < 0.8) {
      return 'Pense bem antes de gastar mais';
    } else if (progress < 1.0) {
      return 'Melhor parar de comprar agora';
    } else {
      return 'Você extrapolou a meta!';
    }
  }

  /// Gera cor baseado no progresso (para UI)
  /// Retorna um valor entre 0 (verde) e 3 (vermelho)
  int getProgressColorIndex(double progress) {
    if (progress < 0.5) return 0; // Verde
    if (progress < 0.75) return 1; // Amarelo
    if (progress < 1.0) return 2; // Laranja
    return 3; // Vermelho
  }

  /// Gera emoji baseado no progresso
  String getProgressEmoji(double progress) {
    if (progress < 0.5) return '✅';
    if (progress < 0.75) return '⚠️';
    if (progress < 1.0) return '🚨';
    return '❌';
  }
}
