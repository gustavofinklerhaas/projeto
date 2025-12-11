import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/data/preferences_service.dart';
import '../../core/constants/app_constants.dart';
import 'new_list_screen.dart';
import 'my_lists_screen.dart';
import 'categories_screen.dart';
import 'share_list_screen.dart';
import 'settings_screen.dart';

/// Tela Home principal
class HomeScreen extends StatefulWidget {
  final VoidCallback? onDarkModeChanged;

  const HomeScreen({Key? key, this.onDarkModeChanged}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  String _username = 'Usuário';
  int _termsReadCount = 0;
  bool _analyticsConsent = false;
  bool _showUndoRevokeConsent = false;
  late DateTime _consentRevokedTime;
  Timer? _revokeTimer;

  @override
  void initState() {
    super.initState();
    _preferencesService.init();
    _loadUserData();
  }

  @override
  void dispose() {
    _revokeTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final readCount = await _preferencesService.getTermsReadCount();
    setState(() {
      _termsReadCount = readCount;
    });
  }

  Future<void> _resetApp() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Semantics(
          label: 'Diálogo de confirmação para resetar aplicativo',
          button: false,
          child: AlertDialog(
            title: const Text('Resetar Aplicativo'),
            content: const Text(
              'Isso limpará todas as suas preferências e voltará para o início do fluxo.',
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
          ),
        );
      },
    );
  }

  Future<void> _revokeConsent() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Semantics(
          label: 'Diálogo de confirmação para revogar consentimento',
          button: false,
          child: AlertDialog(
            title: const Text('Revogar Consentimento'),
            content: const Text(
              'Deseja realmente revogar seu consentimento? Isso o redirecionará para aceitar os termos novamente.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(48, 48),
                ),
                onPressed: () async {
                  await _preferencesService.revokeConsent();
                  if (!mounted) return;
                  Navigator.of(dialogContext).pop();

                  // Cancelar qualquer timer anterior
                  _revokeTimer?.cancel();

                  // Mostrar snackbar com opção desfazer por 5 segundos
                  setState(() {
                    _showUndoRevokeConsent = true;
                    _consentRevokedTime = DateTime.now();
                  });

                  // Flag para controlar se ainda está esperando a navegação
                  bool shouldNavigate = true;

                  // Mostrar snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Consentimento revogado'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () async {
                          // Marca para não navegar
                          shouldNavigate = false;
                          _revokeTimer?.cancel();

                          // Restaura consentimento
                          await _preferencesService.setConsentGiven();
                          if (mounted) {
                            setState(() {
                              _showUndoRevokeConsent = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Consentimento restaurado'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      duration: const Duration(seconds: 5),
                    ),
                  );

                  // Aguarda 5 segundos e redireciona se não fez desfazer
                  _revokeTimer = Timer(const Duration(seconds: 5), () {
                    if (mounted && shouldNavigate) {
                      // Usa o context original da homescreen, não o da dialog
                      Navigator.of(context).pushReplacementNamed('/terms');
                    }
                  });
                },
                child: const Text('Revogar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onDarkModeChanged,
            tooltip: Theme.of(context).brightness == Brightness.dark
                ? 'Modo Claro'
                : 'Modo Escuro',
            iconSize: 24,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen(
                  onDarkModeChanged: widget.onDarkModeChanged,
                )),
              );
            },
            tooltip: 'Configurações',
            iconSize: 24,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho de boas-vindas
            Semantics(
              label: 'Seção de boas-vindas',
              button: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $_username! 👋',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bem-vindo ao Shopping List',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Card de Status de Aceitação de Termos
            _buildStatusCard(
              context: context,
              title: 'Termos Aceitos',
              subtitle: 'Versão 1.0.0',
              description: 'Você leu os termos $_termsReadCount vez(es)',
              icon: Icons.verified,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),

            // Card de Consentimento
            _buildStatusCard(
              context: context,
              title: 'Consentimento Dado',
              subtitle: 'Dados Protegidos',
              description: 'Suas preferências de dados estão salvas com segurança',
              icon: Icons.security,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 32),

            // Seção de Ações
            Text(
              'Ações Rápidas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // Grade de ações
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildActionCard(
                  context: context,
                  title: 'Nova Lista',
                  icon: Icons.add_shopping_cart,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NewListScreen(),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context: context,
                  title: 'Minhas Listas',
                  icon: Icons.list,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyListsScreen(),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context: context,
                  title: 'Categorias',
                  icon: Icons.category,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CategoriesScreen(),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context: context,
                  title: 'Compartilhar',
                  icon: Icons.share,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ShareListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Seção de Informações de Privacidade
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip,
                        color: Colors.blue,
                        semanticLabel: 'Ícone de privacidade',
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sua Privacidade é Importante',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.blue,
                                  ),
                          semanticsLabel: 'Título: Sua Privacidade é Importante',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Você está em conformidade com a LGPD (Lei Geral de Proteção de Dados Pessoais). Seus dados estão criptografados e sua privacidade é nossa prioridade.',
                    style: Theme.of(context).textTheme.bodySmall,
                    semanticsLabel:
                        'Informação sobre conformidade com LGPD e proteção de dados',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botões de Ações Avançadas
            Text(
              'Configurações Avançadas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // Botão de Revogar Consentimento
            SizedBox(
              width: double.infinity,
              height: AppConstants.minTouchSize,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, AppConstants.minTouchSize),
                ),
                onPressed: _revokeConsent,
                icon: const Icon(Icons.gpp_bad),
                label: const Text(
                  'Revogar Consentimento',
                  semanticsLabel: 'Botão para revogar consentimento de dados',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Botão de Reset
            SizedBox(
              width: double.infinity,
              height: AppConstants.minTouchSize,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppConstants.minTouchSize),
                ),
                onPressed: _resetApp,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Resetar Aplicativo',
                  semanticsLabel: 'Botão Resetar Aplicativo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Semantics(
      label: 'Card de status: $title',
      button: false,
      child: Container(
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
                  semanticLabel: title,
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
                    semanticsLabel: 'Título: $title',
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                    semanticsLabel: 'Subtítulo: $subtitle',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                    semanticsLabel: 'Descrição: $description',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: 'Botão de ação: $title',
      button: true,
      enabled: true,
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppConstants.minTouchSize,
              minWidth: AppConstants.minTouchSize,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                  semanticLabel: title,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    semanticsLabel: title,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
