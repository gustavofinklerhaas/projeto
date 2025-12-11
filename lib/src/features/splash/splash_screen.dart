import 'package:flutter/material.dart';
import '../../core/data/preferences_service.dart';
import '../../core/constants/app_constants.dart';

/// Tela Splash que decide o fluxo do usuário
class SplashScreen extends StatefulWidget {
  final VoidCallback? onDarkModeChanged;

  const SplashScreen({Key? key, this.onDarkModeChanged}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Inicializa o serviço de preferências
    await _preferencesService.init();

    // Aguarda o tempo da splash
    await Future.delayed(Duration(seconds: AppConstants.splashDurationSeconds));

    if (!mounted) return;

    // Verifica se o usuário já aceitou os termos
    final termsAccepted = await _preferencesService.areTermsAccepted();
    final consentGiven = await _preferencesService.isConsentGiven();
    final onboardingCompleted =
        await _preferencesService.isOnboardingCompleted();

    // Verifica se a versão dos termos foi atualizada
    final termsVersionOutdated = await _preferencesService
        .isTermsVersionOutdated(AppConstants.currentTermsVersion);

    if (!mounted) return;

    // Lógica de decisão de rota
    // 1. Se versão dos termos foi atualizada, forçar aceitar novamente
    if (termsVersionOutdated) {
      Navigator.of(context).pushReplacementNamed('/terms');
      return;
    }

    // 2. Se não fez onboarding, vai para onboarding
    if (!onboardingCompleted) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
      return;
    }

    // 3. Se não aceitou termos ou não deu consentimento, vai para termos
    if (!termsAccepted || !consentGiven) {
      Navigator.of(context).pushReplacementNamed('/terms');
      return;
    }

    // 4. Tudo ok, vai direto para home
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo da aplicação
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_cart,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Título da aplicação
            Text(
              'Shopping List',
              style: Theme.of(context).textTheme.displaySmall,
              semanticsLabel: 'Aplicação Shopping List',
            ),
            const SizedBox(height: 16),
            // Indicador de carregamento com acessibilidade
            Semantics(
              label: 'Carregando aplicação',
              button: false,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
