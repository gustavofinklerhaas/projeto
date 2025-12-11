import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  /// PageController - declarado como late final para inicialização garantida
  late final PageController _pageController;
  
  /// Página atual do PageView
  int _currentPage = 0;

  /// Lista de telas de onboarding
  final List<OnboardingScreen> onboardingScreens = [
    OnboardingScreen(
      image: '🛒',
      title: 'Bem-vindo!',
      description: 'Gerencie suas compras de forma fácil e prática.',
    ),
    OnboardingScreen(
      image: '✅',
      title: 'Organizado',
      description: 'Crie listas e acompanhe seus itens em tempo real.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Inicializa o PageController ANTES de usá-lo
    _pageController = PageController();
    
    // Adiciona listener para atualizar a página atual
    _pageController.addListener(_updateCurrentPage);
  }

  /// Callback para atualizar a página atual quando o usuário faz swipe
  void _updateCurrentPage() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
    });
  }

  /// Navega para a próxima página
  void _nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navega para a página inicial (Home)
  void _handleStartButton() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    // Limpa o PageController para evitar vazamento de memória
    _pageController.removeListener(_updateCurrentPage);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// PageView com as telas de onboarding
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingScreens.length,
                itemBuilder: (context, index) {
                  return OnboardingScreenWidget(
                    screen: onboardingScreens[index],
                  );
                },
              ),
            ),
            
            /// Controles: indicadores, botões
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Indicadores de página
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingScreens.length,
                      (index) => Semantics(
                        label: _currentPage == index
                            ? 'Página ${index + 1} selecionada'
                            : 'Página ${index + 1}',
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentPage == index
                                ? const Color(0xFF6200EE)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Botão "Começar" na última página
                  if (_currentPage == onboardingScreens.length - 1)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleStartButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6200EE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Começar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          semanticsLabel: 'Começar a usar o app',
                        ),
                      ),
                    ),
                  
                  // Botão "Próximo" nas outras páginas
                  if (_currentPage < onboardingScreens.length - 1)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6200EE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Próximo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modelo de dados para telas de onboarding
class OnboardingScreen {
  final String image;
  final String title;
  final String description;

  OnboardingScreen({
    required this.image,
    required this.title,
    required this.description,
  });
}

/// Widget que exibe uma única tela de onboarding
class OnboardingScreenWidget extends StatelessWidget {
  final OnboardingScreen screen;

  const OnboardingScreenWidget({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container com emoji/imagem
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFEDDEFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                screen.image,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Título
          Text(
            screen.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            semanticsLabel: screen.title,
          ),
          const SizedBox(height: 16),
          
          // Descrição
          Text(
            screen.description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            semanticsLabel: screen.description,
          ),
        ],
      ),
    );
  }
}
