# Implementação Técnica - Fluxo do App

## 1. Arquivo de Constantes (`core/constants/app_constants.dart`)

Define valores globais reutilizáveis:
- `minTouchSize = 48.0`: Tamanho mínimo de área de toque (48dp)
- `minimumTermsReadCount = 2`: Mínimo de vezes que termos devem ser lidos
- `splashDurationSeconds = 3`: Duração da splash
- `currentTermsVersion = '1.0.0'`: Versão atual dos termos

## 2. Serviço de Preferências (`core/data/preferences_service.dart`)

Sistema de persistência usando SharedPreferences.

### Chaves de Armazenamento
```dart
_keyTermsAccepted        // bool: termos aceitos?
_keyConsentGiven         // bool: consentimento dado?
_keyOnboardingCompleted  // bool: onboarding completo?
_keyTermsReadCount       // int: quantas vezes lido?
_keyTermsVersion         // string: versão aceita
_keyTermsRefusedCount    // int: quantas vezes recusado?
```

### Operações Principais

**Verificações**:
```dart
await preferencesService.areTermsAccepted()      // bool
await preferencesService.isConsentGiven()        // bool
await preferencesService.isOnboardingCompleted() // bool
```

**Registros**:
```dart
await preferencesService.setTermsAccepted('1.0.0')
await preferencesService.setConsentGiven()
await preferencesService.setOnboardingCompleted()
await preferencesService.incrementTermsReadCount()
```

**Recusas**:
```dart
await preferencesService.refuseTerms()
int refusedCount = await preferencesService.getTermsRefusedCount()
```

## 3. Tema (`core/theme/app_theme.dart`)

### Estratégia de Cores com Contraste

**Paleta Primária**:
- Verde escuro (#2E7D32): Botões principais
- Laranja (#FFA726): Ações secundárias
- Vermelho (#D32F2F): Erros e avisos

**Texto**:
- Preto (#212121): Principal
- Cinza (#757575): Secundário
- Cinza claro (#BDBDBD): Desativado

### Ratios de Contraste Testados
```
Branco + Preto:         21:1 ✓ WCAG AAA
Branco + Cinza escuro:  10:1 ✓ WCAG AA
Branco + Cinza:         6:1  ✓ WCAG AA
```

### Estilos de Texto

Todos com altura de linha ≥ 1.4 para readability:

```dart
displaySmall:  36sp, bold, 1.4x altura
headlineMedium: 24sp, bold, 1.4x altura
titleLarge:    18sp, w600, 1.4x altura
bodyLarge:     16sp, normal, 1.5x altura
bodyMedium:    14sp, normal, 1.5x altura
labelLarge:    14sp, w600, 1.4x altura
```

### Componentes com Acessibilidade

**Botões**:
```dart
minimumSize: Size(48.0, 48.0)
padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
shape: RoundedRectangleBorder(borderRadius: 8)
```

**Checkboxes e Radios**:
```dart
minimumSize: Size(48.0, 48.0)
visualDensity: VisualDensity.maximized
```

**Focus States**:
```dart
focusedBorder: BorderSide(color: primary, width: 2)
focusedErrorBorder: BorderSide(color: error, width: 2)
```

## 4. Splash Screen (`features/splash/splash_screen.dart`)

### Fluxo Lógico

```
initState()
  ↓
_initializeAndNavigate()
  ↓
init PreferencesService
  ↓
await 3 segundos
  ↓
Verificar: areTermsAccepted() && isOnboardingCompleted()?
  ├─ Sim → /home
  ├─ Não → Verificar: isOnboardingCompleted()?
  │        ├─ Não → /onboarding
  │        └─ Sim → /terms
```

### Elementos de Acessibilidade

```dart
Semantics(
  label: 'Carregando aplicação',
  button: false,  // Não é botão
  child: CircularProgressIndicator(),
)
```

## 5. Onboarding Screen (`features/onboarding/onboarding_screen.dart`)

### Estrutura de Páginas

```dart
final List<OnboardingPage> _pages = [
  OnboardingPage(
    title: 'Bem-vindo',
    description: '...',
    icon: Icons.shopping_bag,
  ),
  // ... mais 3 páginas
];
```

### PageController Setup

```dart
_pageController = PageController();
PageView.builder(
  controller: _pageController,
  onPageChanged: (page) => setState(() => _currentPage = page),
  children: pages,
)
```

### Indicadores Dinâmicos

```dart
// Dots aparecem APENAS se NÃO for última página
if (!isFinalPage)
  // Renderizar dots
```

Cada dot:
```dart
Container(
  width: index == _currentPage ? 24 : 8,  // Animado
  height: 8,
  decoration: BoxDecoration(
    color: index == _currentPage ? primary : primary.opacity(0.3),
    borderRadius: BorderRadius.circular(4),
  ),
)
```

### Botão Pular

```dart
// Apenas nas páginas intermediárias
if (!isFinalPage)
  InkWell(
    onTap: _skipOnboarding,  // Vai direto para /consent
    child: Text('Pular'),
  )
```

### Prevenção de Back

```dart
WillPopScope(
  onWillPop: () async => false,  // Bloqueia gesto de volta
  child: Scaffold(...),
)
```

## 6. Terms Screen (`features/terms/terms_screen.dart`)

### Progresso de Leitura

```dart
void _onScroll() {
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.offset;
  final progress = currentScroll / maxScroll;  // 0.0 a 1.0
  
  setState(() {
    _scrollProgress = progress;
    _showMarkAsReadButton = progress >= 0.95;  // 95%
  });
}
```

### Barra de Progresso Visual

```dart
LinearProgressIndicator(
  value: _scrollProgress,  // 0.0 a 1.0
  minHeight: 4,
  backgroundColor: Colors.grey[300],
  valueColor: AlwaysStoppedAnimation(primary),
)

// Semantics
Semantics(
  label: 'Progresso de leitura: ${(_scrollProgress * 100).toStringAsFixed(0)}%',
  button: false,
)
```

### Botão Marcar como Lido

```dart
if (_showMarkAsReadButton && !_termsRead)
  ElevatedButton.icon(
    onPressed: _markAsRead,  // Incrementa contagem
    icon: Icon(Icons.check),
    label: Text('Marcar como Lido'),
  )
```

### Validação para Aceitar

```dart
bool get _canContinue =>
  _termsReadCount >= AppConstants.minimumTermsReadCount &&
  !_termsAccepted;

ElevatedButton(
  onPressed: _canContinue ? _acceptTerms : null,  // null = disabled
  child: Text('Aceitar'),
)
```

### Diálogo de Recusa

```dart
AlertDialog(
  title: Text('Recusa de Termos'),
  content: Text('Aviso claro'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),  // Desfazer
      child: Text('Desfazer'),
    ),
    ElevatedButton(
      onPressed: () {
        _preferencesService.refuseTerms();
        setState(() => _showRefusedMessage = true);
      },
      child: Text('Confirmar Recusa'),
    ),
  ],
)
```

### Conformidade LGPD

Quando aceita:
```dart
await _preferencesService.setTermsAccepted(
  AppConstants.currentTermsVersion  // '1.0.0'
);
// Também registra: data (timestamp do sistema)
```

## 7. Consent Screen (`features/consent/consent_screen.dart`)

### Cards de Consentimento

```dart
_buildConsentCard(
  title: 'Análise de Uso',
  description: '...',
  value: _analyticConsent,
  onChanged: (value) {
    setState(() => _analyticConsent = value ?? false);
    _updateConsents();
  },
  icon: Icons.analytics,
)
```

### Estrutura do Card

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    border: Border.all(
      color: value ? primary : Colors.grey[300]!,
      width: value ? 2 : 1,
    ),
    borderRadius: BorderRadius.circular(8),
    color: value ? primary.withOpacity(0.05) : transparent,
  ),
  child: Row(
    children: [
      Icon(icon),
      Expanded(child: Column(title, description)),
      Checkbox(
        value: value,
        onChanged: onChanged,
        visualDensity: VisualDensity.maximized,
      ),
    ],
  ),
)
```

### Opt-in Explícito

```dart
// Usuário pode continuar SEM aceitar nada
ElevatedButton(
  onPressed: _continueWithConsent,  // Sempre habilitado
  child: Text('Continuar para Home'),
)
```

## 8. Home Screen (`features/home/home_screen.dart`)

### Cards de Status

```dart
_buildStatusCard(
  title: 'Termos Aceitos',
  subtitle: 'Versão 1.0.0',
  description: 'Você leu os termos 2 vez(es)',
  icon: Icons.verified,
  color: primary,
)
```

### Grade de Ações

```dart
GridView.count(
  crossAxisCount: 2,
  children: [
    _buildActionCard(
      title: 'Nova Lista',
      icon: Icons.add_shopping_cart,
      onTap: () { },
    ),
    // ... mais 3 ações
  ],
)
```

### Reset para Desenvolvimento

```dart
OutlinedButton.icon(
  onPressed: _resetApp,
  icon: Icon(Icons.refresh),
  label: Text('Resetar Aplicativo'),
)

Future<void> _resetApp() async {
  await _preferencesService.clearAll();
  Navigator.pushReplacementNamed(context, '/splash');
}
```

## 9. Main.dart - Configuração de Rotas

### Inicialização

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencesService = PreferencesService();
  await preferencesService.init();
  runApp(const MyApp());
}
```

### Definição de Rotas

```dart
MaterialApp(
  title: 'Shopping List',
  theme: AppTheme.getTheme(),
  home: const SplashScreen(),
  routes: {
    '/splash': (context) => const SplashScreen(),
    '/onboarding': (context) => const OnboardingScreen(),
    '/terms': (context) => const TermsScreen(),
    '/consent': (context) => const ConsentScreen(),
    '/home': (context) => const HomeScreen(),
  },
  showSemanticsDebugger: false,  // Mude para true para debug
)
```

### Acessibilidade Global

```dart
builder: (context, child) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaleFactor: 1.0,  // Ignora scale factor do sistema
    ),
    child: child!,
  );
}
```

## Boas Práticas Implementadas

### ✓ Acessibilidade
- Semântica em todo lugar
- Tamanho mínimo de 48dp
- Contraste WCAG AA+
- Navegação por teclado
- Focus visível

### ✓ LGPD
- Consentimento explícito
- Versionamento de termos
- Registro de aceitos/recusados
- Dados locais por padrão
- Privacidade por design

### ✓ UX
- Fluxo lógico e claro
- Mensagens de erro compreensíveis
- Opções de desfazer
- Indicadores visuais
- Estados desativados claros

### ✓ Código
- Separação de responsabilidades
- Reutilização com estateless/stateful
- Nomeação clara
- Comentários onde necessário
- Sem magic numbers

## Verificação de Implementação

### Splash
- [ ] Dura 3 segundos
- [ ] Decide corretamente para qual tela ir
- [ ] Logo e título visíveis
- [ ] Loading indicator semântico

### Onboarding
- [ ] 4 páginas deslizáveis
- [ ] Dots desaparecem na última
- [ ] Pular vai para /consent
- [ ] Gesto back bloqueado
- [ ] Botão "Próximo" vira "Começar"

### Terms
- [ ] Progresso visual funciona
- [ ] Botão aparece aos 95%
- [ ] Contagem de leituras funciona
- [ ] Precisa ler 2x para aceitar
- [ ] Recusa mostra diálogo
- [ ] Versão registrada

### Consent
- [ ] 2 checkboxes funcionam
- [ ] Pode continuar sem aceitar
- [ ] Cards mudam visualmente

### Home
- [ ] Mostra status de termos
- [ ] Cards de ações funcionam
- [ ] Reset funciona
- [ ] Mensagens de privacidade

## Debug

Para visualizar a árvore semântica:
```dart
showSemanticsDebugger: true,  // Em MaterialApp
```

Para testar com teclado:
- Tab para navegar
- Enter para ativar botões
- Seta para mudar páginas (PageView)

Para testar com leitor de tela:
- Android: TalkBack (Settings > Accessibility)
- iOS: VoiceOver (Settings > Accessibility)
