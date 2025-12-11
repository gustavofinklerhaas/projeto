import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/data/preferences_service.dart';

/// Tela de Termos e Políticas com progresso de leitura
class TermsScreen extends StatefulWidget {
  final VoidCallback? onDarkModeChanged;

  const TermsScreen({Key? key, this.onDarkModeChanged}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  late ScrollController _scrollController;
  final PreferencesService _preferencesService = PreferencesService();
  double _scrollProgress = 0.0;
  bool _showMarkAsReadButton = false;
  int _termsReadCount = 0;
  bool _termsAccepted = false;
  bool _showRefusedMessage = false;

  // Conteúdo dos termos (em pt-BR e com foco em LGPD)
  static const String _termsContent = '''
TERMOS DE USO E POLÍTICAS DE PRIVACIDADE

Versão 1.0.0 - Dezembro de 2025

1. INTRODUÇÃO

Bem-vindo ao Shopping List. Este documento estabelece os termos e condições para o uso do aplicativo, bem como nossas políticas de privacidade em conformidade com a Lei Geral de Proteção de Dados Pessoais (LGPD - Lei 13.709/2018).

2. CONSENTIMENTO E OPT-IN

Ao usar este aplicativo, você consente expressamente com a coleta, processamento e armazenamento de seus dados pessoais conforme descrito neste documento. Você possui o direito de aceitar ou recusar a coleta de dados, e pode revogar este consentimento a qualquer momento através das configurações do aplicativo.

O consentimento é registrado com a data e versão destes termos para auditoria e conformidade.

3. DADOS COLETADOS

Os dados coletados incluem:
- Informações de uso do aplicativo
- Preferências e configurações
- Listas de compras sincronizadas
- Informações de dispositivo (apenas para diagnóstico)

4. ARMAZENAMENTO DE DADOS

Todos os dados são armazenados localmente no seu dispositivo por padrão. Dados sincronizados são criptografados em trânsito e em repouso.

5. DIREITOS DO USUÁRIO

Você tem direito a:
- Acessar seus dados pessoais
- Corrigir dados inexatos
- Solicitar exclusão de dados
- Portar seus dados em formato legível
- Revogar consentimento

6. SEGURANÇA

Implementamos medidas técnicas e organizacionais para proteger seus dados contra acesso não autorizado, alteração e destruição.

7. CONTATO

Para questões de privacidade, entre em contato através de privacy@shoppinglist.app

8. ALTERAÇÕES

Podemos atualizar estes termos periodicamente. A continuidade do uso implica aceitação das alterações.

LEIA CUIDADOSAMENTE E ACEITE PARA CONTINUAR
''';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _preferencesService.init().then((_) {
      _loadTermsReadCount();
    });
  }

  Future<void> _loadTermsReadCount() async {
    final count = await _preferencesService.getTermsReadCount();
    setState(() {
      _termsReadCount = count;
    });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final progress = maxScroll > 0 ? currentScroll / maxScroll : 0.0;

    setState(() {
      _scrollProgress = progress;
      // Mostra o botão "Marcar como lido" quando está próximo ao final (90%)
      // Reduzido de 95% para 90% e permitindo que apareça sempre que o usuário chegar perto do final
      _showMarkAsReadButton = progress >= 0.90;
    });
  }

  Future<void> _markAsRead() async {
    await _preferencesService.incrementTermsReadCount();
    final count = await _preferencesService.getTermsReadCount();

    setState(() {
      _termsReadCount = count;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Termos marcados como lidos ($_termsReadCount/${AppConstants.minimumTermsReadCount})',
          semanticsLabel:
              'Termos marcados como lidos: $_termsReadCount de ${AppConstants.minimumTermsReadCount}',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _acceptTerms() async {
    await _preferencesService
        .setTermsAccepted(AppConstants.currentTermsVersion);

    setState(() {
      _termsAccepted = true;
      _showRefusedMessage = false;
    });

    if (!mounted) return;

    // Navega para Consentimento
    Navigator.of(context).pushReplacementNamed('/consent');
  }

  void _refuseTerms() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Semantics(
          label: 'Diálogo de recusa de termos',
          button: false,
          child: AlertDialog(
            title: Text(
              'Recusa de Termos',
              semanticsLabel: 'Título: Recusa de Termos',
            ),
            content: Text(
              'Você está recusando os termos de uso. Sem aceitar, não será possível usar o aplicativo.',
              semanticsLabel:
                  'Você está recusando os termos de uso. Sem aceitar, não será possível usar o aplicativo.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Desfazer',
                  semanticsLabel: 'Botão Desfazer recusa',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _preferencesService.refuseTerms();
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  setState(() {
                    _showRefusedMessage = true;
                  });
                },
                child: const Text(
                  'Confirmar Recusa',
                  semanticsLabel: 'Botão Confirmar Recusa',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _termsReadCount >= AppConstants.minimumTermsReadCount &&
      _termsAccepted == false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        // Evita sair sem aceitar os termos
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Termos e Políticas'),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            // Barra de progresso de leitura
            Semantics(
              label:
                  'Progresso de leitura: ${(_scrollProgress * 100).toStringAsFixed(0)}%',
              button: false,
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: LinearProgressIndicator(
                  value: _scrollProgress,
                  minHeight: 4,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            // Contador de leituras
            Padding(
              padding: const EdgeInsets.all(16),
              child: Semantics(
                label:
                    'Termos lidos $_termsReadCount de ${AppConstants.minimumTermsReadCount} vezes',
                button: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Leituras: $_termsReadCount/${AppConstants.minimumTermsReadCount}',
                      style: textTheme.bodyMedium,
                    ),
                    if (_termsReadCount >= AppConstants.minimumTermsReadCount)
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        semanticLabel: 'Termos lidos com sucesso',
                      ),
                  ],
                ),
              ),
            ),

            // Conteúdo dos termos (scrollável)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Semantics(
                  label: 'Conteúdo dos termos de uso',
                  button: false,
                  child: Text(
                    _termsContent,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
            ),

            // Botão "Marcar como lido" (aparece quando atinge 90% da página)
            if (_showMarkAsReadButton && _termsReadCount < AppConstants.minimumTermsReadCount)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: AppConstants.minTouchSize,
                  child: ElevatedButton.icon(
                    onPressed: _markAsRead,
                    icon: const Icon(Icons.check),
                    label: const Text(
                      'Marcar como Lido',
                      semanticsLabel: 'Botão Marcar como Lido',
                    ),
                  ),
                ),
              ),

            // Mensagem de recusa (se aplicável)
            if (_showRefusedMessage)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
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
                        semanticLabel: 'Ícone de aviso',
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Você recusou os termos. Aceite para continuar.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          semanticsLabel:
                              'Você recusou os termos. Aceite para continuar.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Botões de ação
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: AppConstants.minTouchSize,
                      child: OutlinedButton(
                        onPressed: _refuseTerms,
                        child: const Text(
                          'Recusar',
                          semanticsLabel: 'Botão Recusar Termos',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: AppConstants.minTouchSize,
                      child: ElevatedButton(
                        onPressed:
                            _termsReadCount >=
                                    AppConstants.minimumTermsReadCount
                                ? _acceptTerms
                                : null,
                        child: const Text(
                          'Aceitar',
                          semanticsLabel: 'Botão Aceitar Termos',
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
