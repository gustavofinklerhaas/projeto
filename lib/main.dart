import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/data/preferences_service.dart';
import 'src/core/di/service_locator.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/features/onboarding/onboarding_screen.dart';
import 'src/features/terms/terms_screen.dart';
import 'src/features/consent/consent_screen.dart';
import 'src/features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o serviço de preferências
  final preferencesService = PreferencesService();
  await preferencesService.init();
  
  // Configura a injeção de dependência
  ServiceLocator.setup();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PreferencesService _preferencesService;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _preferencesService = PreferencesService();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    try {
      final isDark = await _preferencesService.isDarkMode();
      setState(() {
        _isDarkMode = isDark;
      });
    } catch (e) {
      // Default to light mode
      setState(() {
        _isDarkMode = false;
      });
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _preferencesService.setDarkMode(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoppingList',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(
        onDarkModeChanged: _toggleDarkMode,
      ),
      routes: {
        '/splash': (context) => SplashScreen(
          onDarkModeChanged: _toggleDarkMode,
        ),
        '/onboarding': (context) => OnboardingScreen(
          onDarkModeChanged: _toggleDarkMode,
        ),
        '/terms': (context) => TermsScreen(
          onDarkModeChanged: _toggleDarkMode,
        ),
        '/consent': (context) => ConsentScreen(
          onDarkModeChanged: _toggleDarkMode,
        ),
        '/home': (context) => HomeScreen(
          onDarkModeChanged: _toggleDarkMode,
        ),
      },
      // Configuração de acessibilidade
      showSemanticsDebugger: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Garante tamanho mínimo de fonte de 14pt para acessibilidade
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
    );
  }
}
