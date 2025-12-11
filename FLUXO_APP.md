# Fluxo de App - Documentação Completa

## Visão Geral

Este documento descreve o fluxo completo do aplicativo Shopping List com as telas de Splash, Onboarding, Termos/Políticas, Consentimento e Home.

## Arquitetura

```
lib/src/
├── core/
│   ├── constants/
│   │   └── app_constants.dart (Constantes globais)
│   ├── data/
│   │   └── preferences_service.dart (Gerenciar preferências locais)
│   └── theme/
│       └── app_theme.dart (Tema com acessibilidade)
├── features/
│   ├── splash/
│   │   └── splash_screen.dart (Tela inicial)
│   ├── onboarding/
│   │   └── onboarding_screen.dart (Páginas deslizáveis)
│   ├── terms/
│   │   └── terms_screen.dart (Termos com progresso)
│   ├── consent/
│   │   └── consent_screen.dart (Consentimento opt-in)
│   └── home/
│       └── home_screen.dart (Tela principal)
└── main.dart (Ponto de entrada)
```

## Fluxo de Navegação

### 1. Splash Screen
- **Duração**: 3 segundos
- **Lógica de Decisão**:
  - Se termos aceitos E onboarding completo → Vai para **Home**
  - Se onboarding não completo → Vai para **Onboarding**
  - Se termos não aceitos → Vai para **Termos**

### 2. Onboarding Screen
- **Características**:
  - 4 páginas deslizáveis
  - Indicadores de página (dots) que desaparecem na última página
  - Botão "Pular" que leva direto para **Consentimento** (não para o fim)
  - Gesto de volta desabilitado
  
- **Páginas**:
  1. Bem-vindo
  2. Organizado
  3. Sincronizador
  4. Comece Agora

### 3. Terms Screen
- **Características**:
  - Barra de progresso de leitura (0-100%)
  - Contador de leituras: "Lidas X/2"
  - Botão "Marcar como Lido" aparece apenas ao final do texto (95%+)
  - Usuário deve ler 2 vezes para aceitar
  - Botão "Aceitar" desativado até ler 2 vezes
  - Botão "Recusar" mostra diálogo com opção "Desfazer"
  
- **Conformidade LGPD**:
  - Versão do termo registrada: `1.0.0`
  - Data de aceitação registrada automaticamente
  - Opt-in explícito (usuário decide aceitar)

### 4. Consent Screen
- **Características**:
  - Opt-in para Análise de Uso
  - Opt-in para Comunicações de Marketing
  - Usuário pode continuar sem aceitar nenhum consentimento
  - Botões com acessibilidade completa
  - Informações sobre conformidade LGPD
  
- **Dados Capturados**:
  - Preferência de análise
  - Preferência de marketing
  - Data do consentimento

### 5. Home Screen
- **Características**:
  - Exibe status de aceitação de termos
  - Mostra quantas vezes os termos foram lidos
  - Grade de ações rápidas (Nova Lista, Minhas Listas, etc.)
  - Botão de Reset para desenvolvimento
  - Informações sobre privacidade e LGPD

## Requisitos de Acessibilidade Implementados

### 1. Tamanho Mínimo de Toque (48dp)
Todos os componentes interativos têm pelo menos 48dp × 48dp:
- Botões elevados: `minimumSize: const Size(48.0, 48.0)`
- Checkboxes: `visualDensity: VisualDensity.maximized`
- Elementos interativos com `InkWell`

### 2. Contraste Adequado (WCAG AA)
```dart
- Texto principal (preto) sobre branco: 21:1
- Texto secundário (cinza escuro) sobre branco: 10:1
- Cores de ação (verde) com bom contraste
```

### 3. Foco Visível
- Botões e elementos interativos têm bordas visíveis ao focar
- Cores de foco bem definidas (2px de borda quando focado)
- Navegação por teclado suportada

### 4. Semântica
Todos os elementos usam `Semantics`:
```dart
Semantics(
  label: 'Descrição para leitores de tela',
  button: true/false,
  enabled: true/false,
  onTap: callback,
  child: widget,
)
```

### 5. Leitura de Tela
- Labels significativos em todos os componentes
- Descrições de imagens e ícones
- Árvore semântica bem estruturada

## Requisitos LGPD Implementados

### 1. Consentimento Explícito (Opt-in)
- Usuário deve ativamente aceitar os termos
- Botão "Recusar" sempre disponível
- Possibilidade de "Desfazer" recusa

### 2. Registro de Versão
```dart
// Em preferences_service.dart
Future<void> setTermsAccepted(String termsVersion) async {
  await _prefs.setBool(_keyTermsAccepted, true);
  await _prefs.setString(_keyTermsVersion, termsVersion);
}
```

### 3. Registro de Histórico
- Contagem de leituras dos termos
- Contagem de recusas
- Tudo armazenado localmente com SharedPreferences

### 4. Direitos do Usuário
Documentados nos termos:
- ✓ Acessar dados pessoais
- ✓ Corrigir dados
- ✓ Solicitar exclusão
- ✓ Portar dados
- ✓ Revogar consentimento

### 5. Privacidade por Design
- Dados armazenados localmente por padrão
- Criptografia em trânsito
- Sem coleta automática sem consentimento

## Arquivo de Serviço de Preferências

### PreferencesService (`preferences_service.dart`)

**Métodos principais**:

```dart
// Termos
areTermsAccepted()           // Verifica se aceitos
setTermsAccepted(version)    // Marca como aceitos
refuseTerms()                // Marca como recusados
getTermsReadCount()          // Obtém contagem de leituras
incrementTermsReadCount()    // Incrementa leitura
getAcceptedTermsVersion()    // Obtém versão aceita

// Onboarding
isOnboardingCompleted()      // Verifica conclusão
setOnboardingCompleted()     // Marca como completo

// Consentimento
isConsentGiven()             // Verifica consentimento
setConsentGiven()            // Marca consentimento

// Administrativo
resetTermsAcceptance()       // Reseta apenas termos
clearAll()                   // Limpa tudo
```

## Tema da Aplicação (`app_theme.dart`)

### Cores com Contraste WCAG AA
```dart
primaryColor = #2E7D32 (Verde)
primaryDark = #1B5E20
primaryLight = #66BB6A
accentColor = #FFA726 (Laranja)
errorColor = #D32F2F (Vermelho)
```

### Estilos de Texto
- **Display Large**: 36sp, bold, 1.4x linha
- **Headline Medium**: 24sp, bold, 1.4x linha
- **Body Large**: 16sp, normal, 1.5x linha
- **Body Medium**: 14sp, normal, 1.5x linha
- **Label Large**: 14sp, w600, 1.4x linha

Todos com altura de linha ≥ 1.4 para melhor legibilidade.

## Uso do App

### Primeiro Acesso
1. Splash (3s)
2. Onboarding (4 páginas)
3. Termos (ler 2x)
4. Consentimento
5. Home

### Acessos Subsequentes
1. Splash (3s)
2. Home (direto)

### Reset
Clique em "Resetar Aplicativo" na Home para voltar ao início.

## Constantes Importantes

```dart
class AppConstants {
  static const int splashDurationSeconds = 3;
  static const int minimumTermsReadCount = 2;
  static const double minTouchSize = 48.0;
  static const String currentTermsVersion = '1.0.0';
}
```

## Dependências Utilizadas

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
```

## Testes Recomendados

### Acessibilidade
- [ ] Testar com TalkBack (Android) ou VoiceOver (iOS)
- [ ] Verificar navegação apenas por teclado
- [ ] Validar contraste com ferramentas como WCAG Contrast Checker

### Fluxo
- [ ] Primeiro acesso completo
- [ ] Pular onboarding
- [ ] Recusar e desfazer termos
- [ ] Reset do app

### LGPD
- [ ] Verificar se versão dos termos é salva
- [ ] Confirmar que dados são armazenados localmente
- [ ] Validar que opt-in é explícito

## Próximas Funcionalidades

1. Autenticação com Managed Identity (Azure)
2. Sincronização de listas na nuvem
3. Sistema de categorias
4. Compartilhamento de listas
5. Dashboard analytics
6. Notificações push
7. Modo offline completo

## Suporte e Conformidade

- **LGPD**: ✓ Implementado
- **WCAG 2.1 AA**: ✓ Implementado
- **Material Design 3**: ✓ Implementado
- **Flutter Best Practices**: ✓ Implementado
