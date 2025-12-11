# Snippets & Exemplos de Código

## 1. Como Usar PreferencesService

### Verificar Status
```dart
final preferencesService = PreferencesService();
await preferencesService.init();

// Verificar se termos foram aceitos
final termsAccepted = await preferencesService.areTermsAccepted();
if (termsAccepted) {
  print('Usuário já aceitou os termos');
}

// Verificar versão aceita
final version = await preferencesService.getAcceptedTermsVersion();
print('Versão dos termos: $version'); // Output: Versão dos termos: 1.0.0
```

### Registrar Ações
```dart
// Usuário leu os termos uma vez
await preferencesService.incrementTermsReadCount();

// Verificar quantas vezes leu
final readCount = await preferencesService.getTermsReadCount();
print('Lido $readCount vezes'); // Output: Lido 1 vezes

// Registrar aceitar
await preferencesService.setTermsAccepted('1.0.0');

// Registrar consentimento
await preferencesService.setConsentGiven();

// Registrar onboarding completo
await preferencesService.setOnboardingCompleted();
```

### Recusas
```dart
// Usuário recusou os termos
await preferencesService.refuseTerms();

// Verificar quantas vezes recusou
final refusedCount = await preferencesService.getTermsRefusedCount();
print('Recusado $refusedCount vezes');
```

---

## 2. Navegação Entre Telas

### No Splash Screen
```dart
// Decidir para qual tela navegar
Future<void> _initializeAndNavigate() async {
  final termsAccepted = await _preferencesService.areTermsAccepted();
  final onboardingCompleted = await _preferencesService.isOnboardingCompleted();

  if (!mounted) return;

  if (termsAccepted && onboardingCompleted) {
    // Vai direto para Home
    Navigator.of(context).pushReplacementNamed('/home');
  } else if (!onboardingCompleted) {
    // Vai para Onboarding
    Navigator.of(context).pushReplacementNamed('/onboarding');
  } else {
    // Vai para Termos
    Navigator.of(context).pushReplacementNamed('/terms');
  }
}
```

### Pular Onboarding
```dart
// Em onboarding_screen.dart
Future<void> _skipOnboarding() async {
  await _preferencesService.setOnboardingCompleted();
  if (!mounted) return;
  // Vai direto para Consentimento (não para o fim do onboarding)
  Navigator.of(context).pushReplacementNamed('/consent');
}
```

### Ir para Home Após Consentimento
```dart
// Em consent_screen.dart
Future<void> _continueWithConsent() async {
  await _preferencesService.setConsentGiven();
  
  if (!mounted) return;
  
  Navigator.of(context).pushReplacementNamed('/home');
}
```

---

## 3. Componentes Acessíveis

### Botão com Tamanho Mínimo
```dart
// Sempre use minimumSize 48x48
SizedBox(
  width: double.infinity,
  height: AppConstants.minTouchSize, // 48.0
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Botão'),
  ),
)

// Ou mais explícito
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(48.0, 48.0),
  ),
  child: Text('Botão'),
)
```

### Checkbox com Acessibilidade
```dart
Semantics(
  label: 'Checkbox para aceitar termos',
  checked: _isChecked,
  button: true,
  onTap: () => setState(() => _isChecked = !_isChecked),
  child: Checkbox(
    value: _isChecked,
    onChanged: (value) => setState(() => _isChecked = value ?? false),
    visualDensity: const VisualDensity(
      horizontal: VisualDensity.maximized,
      vertical: VisualDensity.maximized,
    ),
  ),
)
```

### Texto com Semântica
```dart
Semantics(
  label: 'Descrição do que está sendo exibido',
  button: false,
  enabled: true,
  child: Text(
    'Seu texto aqui',
    style: Theme.of(context).textTheme.bodyMedium,
    semanticsLabel: 'Rótulo semântico para leitores de tela',
  ),
)
```

### Ícone com Label
```dart
Semantics(
  label: 'Ícone de verificação - termos lidos',
  button: false,
  child: Icon(
    Icons.check_circle,
    color: Colors.green,
    semanticLabel: 'Verificação completa',
  ),
)
```

---

## 4. Barra de Progresso (Termos)

### Controller de Scroll
```dart
@override
void initState() {
  super.initState();
  _scrollController = ScrollController();
  _scrollController.addListener(_onScroll);
}

void _onScroll() {
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.offset;
  final progress = currentScroll / maxScroll; // 0.0 a 1.0

  setState(() {
    _scrollProgress = progress;
    _showMarkAsReadButton = progress >= 0.95; // 95%
  });
}

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}
```

### Barra Visual
```dart
LinearProgressIndicator(
  value: _scrollProgress, // 0.0 a 1.0
  minHeight: 4,
  backgroundColor: Colors.grey[300],
  valueColor: AlwaysStoppedAnimation<Color>(
    Theme.of(context).colorScheme.primary,
  ),
)
```

### Mostrar Botão Apenas no Final
```dart
if (_showMarkAsReadButton && !_termsRead)
  ElevatedButton.icon(
    onPressed: _markAsRead,
    icon: const Icon(Icons.check),
    label: const Text('Marcar como Lido'),
  )
```

---

## 5. Validações Customizadas

### Validar Leitura de Termos
```dart
// Verificar se pode aceitar
bool get _canAccept =>
  _termsReadCount >= AppConstants.minimumTermsReadCount &&
  !_termsAccepted;

// Usar em botão
ElevatedButton(
  onPressed: _canAccept ? _acceptTerms : null, // null = disabled
  child: const Text('Aceitar'),
)
```

### Mostrar Mensagem de Erro
```dart
if (_showRefusedMessage)
  Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.error.withOpacity(0.1),
      border: Border.all(
        color: Theme.of(context).colorScheme.error,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(
          Icons.warning,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Você recusou os termos. Aceite para continuar.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    ),
  )
```

---

## 6. Diálogos

### Diálogo de Recusa de Termos
```dart
void _refuseTerms() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Recusa de Termos'),
        content: const Text(
          'Você está recusando os termos de uso. '
          'Sem aceitar, não será possível usar o aplicativo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Desfazer'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _preferencesService.refuseTerms();
              if (!mounted) return;
              Navigator.of(context).pop();
              setState(() => _showRefusedMessage = true);
            },
            child: const Text('Confirmar Recusa'),
          ),
        ],
      );
    },
  );
}
```

### Diálogo de Confirmação de Reset
```dart
void _resetApp() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Resetar Aplicativo'),
        content: const Text(
          'Isso limpará todas as suas preferências '
          'e voltará para o início do fluxo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _preferencesService.clearAll();
              if (!mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/splash');
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );
}
```

---

## 7. PageView para Onboarding

### Setup Básico
```dart
late PageController _pageController;
int _currentPage = 0;

@override
void initState() {
  super.initState();
  _pageController = PageController();
}

@override
void dispose() {
  _pageController.dispose();
  super.dispose();
}

// PageView
PageView.builder(
  controller: _pageController,
  onPageChanged: (page) {
    setState(() => _currentPage = page);
  },
  children: _pages
    .asMap()
    .entries
    .map((entry) => _buildPage(entry.value))
    .toList(),
)
```

### Navegação
```dart
void _nextPage() {
  if (_currentPage < _pages.length - 1) {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  } else {
    _goToTerms(); // Última página
  }
}
```

### Indicadores (Dots)
```dart
// Apenas se não for última página
if (!isFinalPage)
  Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentPage
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ),
  )
```

---

## 8. Cards Customizados

### Card de Status
```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: color.withOpacity(0.05),
    border: Border.all(
      color: color,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ],
  ),
)
```

### Card de Consentimento (Interativo)
```dart
Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: () => onChanged(!value),
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: value
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300]!,
          width: value ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: value
          ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
          : Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: value ? primary : Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(...)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(...)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Checkbox(
            value: value,
            onChanged: onChanged,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.maximized,
              vertical: VisualDensity.maximized,
            ),
          ),
        ],
      ),
    ),
  ),
)
```

---

## 9. Bloquear Navegação de Volta

### WillPopScope
```dart
@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      // Retorna false para bloquear o gesto
      return false;
    },
    child: Scaffold(...),
  );
}
```

### Ou permitir apenas em certas condições
```dart
WillPopScope(
  onWillPop: () async {
    // Só permite voltar se estiver na primeira página
    if (_currentPage == 0) {
      return true;
    }
    // Voltar para página anterior
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    return false;
  },
  child: Scaffold(...),
)
```

---

## 10. SnackBar com Acessibilidade

### Notificação Simples
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'Termos marcados como lidos (2/2)',
      semanticsLabel: 'Notificação: Termos marcados como lidos 2 de 2',
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    duration: const Duration(seconds: 2),
  ),
)
```

### Com Ação
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Termos recusados'),
    action: SnackBarAction(
      label: 'Desfazer',
      onPressed: () {
        // Ação de desfazer
      },
    ),
    backgroundColor: Theme.of(context).colorScheme.error,
  ),
)
```

---

## 11. Inicializar App com Preferências

### Main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar PreferencesService
  final preferencesService = PreferencesService();
  await preferencesService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/terms': (context) => const TermsScreen(),
        '/consent': (context) => const ConsentScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
```

---

## 12. Temas Customizados

### Usar Tema em Widgets
```dart
// Cor primária
Color primary = Theme.of(context).colorScheme.primary;

// Texto
Text(
  'Título',
  style: Theme.of(context).textTheme.headlineMedium,
)

// Botão
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  onPressed: () {},
  child: const Text('Botão'),
)
```

---

## 13. Debug de Semântica

### Visualizar Árvore Semântica
```dart
// Em main.dart
MaterialApp(
  showSemanticsDebugger: true, // Mude para true para debug
  // ...
)
```

Isso vai exibir caixas ao redor de cada elemento semântico.

---

## 14. Testar PreferencesService (Unit Test)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PreferencesService preferencesService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferencesService = PreferencesService();
    await preferencesService.init();
  });

  test('acceptTerms salva corretamente', () async {
    await preferencesService.setTermsAccepted('1.0.0');
    
    final accepted = await preferencesService.areTermsAccepted();
    final version = await preferencesService.getAcceptedTermsVersion();
    
    expect(accepted, true);
    expect(version, '1.0.0');
  });

  test('readCount incrementa corretamente', () async {
    await preferencesService.incrementTermsReadCount();
    await preferencesService.incrementTermsReadCount();
    
    final count = await preferencesService.getTermsReadCount();
    expect(count, 2);
  });
}
```

---

## 15. Variáveis Globais para Constantes

### AppConstants (já incluído)
```dart
class AppConstants {
  static const int splashDurationSeconds = 3;
  static const int minimumTermsReadCount = 2;
  static const double minTouchSize = 48.0;
  static const String currentTermsVersion = '1.0.0';
}

// Usar em qualquer lugar
await prefs.setTermsAccepted(AppConstants.currentTermsVersion);
SizedBox(height: AppConstants.minTouchSize)
```

---

## 16. Customizar Termos

### Alterar Conteúdo dos Termos
```dart
// Em terms_screen.dart
static const String _termsContent = '''
SEUS TERMOS AQUI

Seção 1: ...
Seção 2: ...
Seção 3: ...
''';

// SingleChildScrollView já está usando essa string
SingleChildScrollView(
  controller: _scrollController,
  padding: const EdgeInsets.all(16),
  child: Text(_termsContent),
)
```

### Customizar Consentimentos
```dart
// Em consent_screen.dart, adicione mais cards:
_buildConsentCard(
  title: 'Seu Novo Consentimento',
  description: 'Descrição clara',
  value: _newConsent,
  onChanged: (value) {
    setState(() => _newConsent = value ?? false);
    _updateConsents();
  },
  icon: Icons.your_icon,
)
```

---

**Agora você tem exemplos prontos para implementar qualquer funcionalidade adicional!** ✨
