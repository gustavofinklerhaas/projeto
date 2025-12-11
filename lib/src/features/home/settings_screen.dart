import 'package:flutter/material.dart';

/// Tela de Configurações da aplicação
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onDarkModeChanged;

  const SettingsScreen({Key? key, this.onDarkModeChanged}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _sortOrder = 'alfabética';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Seção: Notificações
            _buildSection(
              title: 'Notificações',
              children: [
                Semantics(
                  label: 'Ativar notificações',
                  enabled: true,
                  child: SwitchListTile(
                    title: const Text('Notificações'),
                    subtitle: const Text('Receber lembretes de compras'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? 'Notificações ativadas'
                                : 'Notificações desativadas',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Seção: Aparência
            _buildSection(
              title: 'Aparência',
              children: [
                Semantics(
                  label: 'Ativar modo escuro',
                  enabled: true,
                  child: SwitchListTile(
                    title: const Text('Modo Escuro'),
                    subtitle: const Text('Alternar entre modo claro e escuro'),
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) {
                      widget.onDarkModeChanged?.call();
                    },
                  ),
                ),
              ],
            ),

            // Seção: Dados
            _buildSection(
              title: 'Dados e Privacidade',
              children: [
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Termos de Uso'),
                  subtitle: const Text('Versão 1.0.0'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abrindo Termos de Uso'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Política de Privacidade'),
                  subtitle: const Text('LGPD Compliant'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abrindo Política de Privacidade'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_sweep),
                  title: const Text('Limpar Dados'),
                  subtitle: const Text('Remover todas as listas'),
                  onTap: () {
                    _showClearDataDialog();
                  },
                ),
              ],
            ),

            // Seção: Sobre
            _buildSection(
              title: 'Sobre',
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Versão do App'),
                  subtitle: Text('1.0.0'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Reportar Problema'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abrindo formulário de feedback'),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
        const SizedBox(height: 8),
      ],
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Dados?'),
        content: const Text(
          'Isso removerá todas as suas listas de compras. Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dados removidos com sucesso'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Limpar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
