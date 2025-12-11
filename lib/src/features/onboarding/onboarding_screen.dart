import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/data/preferences_service.dart';

/// Tela de Onboarding com páginas deslizáveis
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onDarkModeChanged;

  const OnboardingScreen({Key? key, this.onDarkModeChanged}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final PreferencesService _preferencesService = PreferencesService();

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bem-vindo',
      description: 'Gerencie suas listas de compras de forma fácil e rápida',
      icon: Icons.shopping_bag,
    ),
    OnboardingPage(
      title: 'Organizado',
      description: 'Organize suas compras por categorias e prioridades',
      icon: Icons.category,
    ),
    OnboardingPage(
      title: 'Sincronizador',
      description: 'Compartilhe suas listas com familiares',
      icon: Icons.people,
    ),
    OnboardingPage(
      title: 'Comece Agora',
      description: 'Vamos começar a usar o aplicativo',
      icon: Icons.check_circle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _preferencesService.init();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToTerms();
    }
  }

  Future<void> _goToTerms() async {
    await _preferencesService.setOnboardingCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/terms');
  }

  Future<void> _skipOnboarding() async {
    await _preferencesService.setOnboardingCompleted();
    if (!mounted) return;
    // Vai direto para Consentimento
    Navigator.of(context).pushReplacementNamed('/consent');
  }

  @override
  Widget build(BuildContext context) {
    final isFinalPage = _currentPage == _pages.length - 1;

    return WillPopScope(
      onWillPop: () async {
        // Evita sair do onboarding com gesto de volta
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // PageView com as páginas do onboarding
            PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              children: _pages
                  .asMap()
                  .entries
                  .map((entry) => _buildOnboardingPage(entry.value))
                  .toList(),
            ),

            // Posicionado no topo: Botão Pular (apenas nas páginas intermediárias)
            if (!isFinalPage)
              Positioned(
                top: 48,
                right: 16,
                child: Semantics(
                  button: true,
                  enabled: true,
                  onTap: _skipOnboarding,
                  label: 'Pular onboarding e ir para consentimento',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _skipOnboarding,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          'Pular',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          semanticsLabel: 'Botão Pular',
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Posicionado embaixo: Indicadores de página (apenas se não for última)
            if (!isFinalPage)
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Semantics(
                  label:
                      'Indicador de página ${_currentPage + 1} de ${_pages.length}',
                  button: false,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Semantics(
                          label: index == _currentPage
                              ? 'Página atual $index'
                              : 'Página $index',
                          button: false,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == _currentPage ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Botão de ação (embaixo)
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: SizedBox(
                height: AppConstants.minTouchSize,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    isFinalPage ? 'Começar' : 'Próximo',
                    semanticsLabel: isFinalPage
                        ? 'Botão Começar'
                        : 'Botão Próximo página',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ícone
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              page.icon,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
              semanticLabel: page.title,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Título
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            page.title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
            semanticsLabel: 'Título: ${page.title}',
          ),
        ),
        const SizedBox(height: 16),

        // Descrição
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
            semanticsLabel: 'Descrição: ${page.description}',
          ),
        ),
      ],
    );
  }
}

/// Modelo de página do onboarding
class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}
