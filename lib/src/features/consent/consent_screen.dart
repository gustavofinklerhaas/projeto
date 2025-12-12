import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/data/preferences_service.dart';

/// Tela de Consentimento com opt-in para coleta de dados
class ConsentScreen extends StatefulWidget {
  final VoidCallback? onDarkModeChanged;

  const ConsentScreen({Key? key, this.onDarkModeChanged}) : super(key: key);

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  bool _analyticConsent = false;
  bool _marketingConsent = false;

  @override
  void initState() {
    super.initState();
    _preferencesService.init();
  }

  Future<void> _continueWithConsent() async {
    // Registra que o consentimento foi dado
    await _preferencesService.setConsentGiven();

    if (!mounted) return;

    // Navega para Home
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _updateConsents() {
    setState(() {
      _allConsentsGiven = _analyticConsent || _marketingConsent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Evita sair sem aceitar o consentimento
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Consentimento e Dados'),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Semantics(
                label: 'Seção de consentimento para coleta de dados',
                button: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suas Preferências de Dados',
                      style: Theme.of(context).textTheme.headlineMedium,
                      semanticsLabel: 'Título: Suas Preferências de Dados',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Escolha quais dados você deseja compartilhar conosco. Você pode modificar essas preferências a qualquer momento nas configurações.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      semanticsLabel:
                          'Escolha quais dados você deseja compartilhar conosco. Você pode modificar essas preferências a qualquer momento nas configurações.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Seção de Análise
              _buildConsentCard(
                context: context,
                title: 'Análise de Uso',
                description:
                    'Nos ajude a melhorar o aplicativo coletando dados sobre como você o usa. Seus dados serão anonimizados.',
                value: _analyticConsent,
                onChanged: (value) {
                  setState(() => _analyticConsent = value ?? false);
                  _updateConsents();
                },
                icon: Icons.analytics,
                semanticsLabel:
                    'Ativar análise de uso do aplicativo - Nos ajude a melhorar',
              ),
              const SizedBox(height: 16),

              // Seção de Marketing
              _buildConsentCard(
                context: context,
                title: 'Comunicações de Marketing',
                description:
                    'Receba atualizações sobre novos recursos e ofertas especiais. Você pode cancelar a inscrição a qualquer momento.',
                value: _marketingConsent,
                onChanged: (value) {
                  setState(() => _marketingConsent = value ?? false);
                  _updateConsents();
                },
                icon: Icons.email,
                semanticsLabel:
                    'Ativar comunicações de marketing - Receba atualizações sobre novos recursos',
              ),
              const SizedBox(height: 32),

              // Caixa de informações importantes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
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
                          Icons.info,
                          color: Theme.of(context).colorScheme.primary,
                          semanticLabel: 'Ícone de informação',
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Informações Importantes',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            semanticsLabel: 'Subseção: Informações Importantes',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Todos os seus dados estão protegidos por criptografia\n'
                      '• Você pode revogar este consentimento a qualquer momento\n'
                      '• Suas preferências serão registradas com data e versão dos termos\n'
                      '• Estamos em conformidade com a LGPD',
                      style: Theme.of(context).textTheme.bodySmall,
                      semanticsLabel:
                          'Pontos importantes sobre proteção de dados e seu consentimento',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botão de Continuar
              SizedBox(
                width: double.infinity,
                height: AppConstants.minTouchSize,
                child: ElevatedButton(
                  onPressed: _continueWithConsent,
                  child: const Text(
                    'Continuar para Home',
                    semanticsLabel: 'Botão Continuar para Home',
                  ),
                ),
              ),

              // Informação sobre não aceitar nada
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Você pode continuar sem aceitar nenhum consentimento',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  semanticsLabel:
                      'Você pode continuar sem aceitar nenhum consentimento',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentCard({
    required BuildContext context,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
    required String semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      enabled: true,
      onTap: () => onChanged(!value),
      child: Material(
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
                // Ícone
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    icon,
                    color: value
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    semanticLabel: title,
                  ),
                ),
                const SizedBox(width: 16),

                // Conteúdo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: value
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).textTheme.titleMedium?.color,
                          fontWeight: value ? FontWeight.bold : FontWeight.w600,
                        ),
                        semanticsLabel: 'Título: $title',
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
                const SizedBox(width: 12),

                // Checkbox
                Semantics(
                  checked: value,
                  button: true,
                  enabled: true,
                  label: 'Checkbox para $title',
                  onTap: () => onChanged(!value),
                  child: Checkbox(
                    value: value,
                    onChanged: onChanged,
                    visualDensity: VisualDensity.compact,
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
