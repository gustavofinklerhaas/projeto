import 'package:flutter/material.dart';

/// Tela para compartilhar listas de compras
class ShareListScreen extends StatefulWidget {
  const ShareListScreen({Key? key}) : super(key: key);

  @override
  State<ShareListScreen> createState() => _ShareListScreenState();
}

class _ShareListScreenState extends State<ShareListScreen> {
  final List<Map<String, dynamic>> _sharedLists = [
    {
      'name': 'Supermercado - Semana',
      'sharedWith': 'Maria, João',
      'date': 'Há 2 dias',
    },
    {
      'name': 'Padaria',
      'sharedWith': 'Mãe',
      'date': 'Há 1 semana',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartilhar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    semanticLabel: 'Ícone de informação',
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Compartilhe suas listas com amigos e familiares',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Título
            Text(
              'Listas Compartilhadas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Lista de compartilhamentos
            if (_sharedLists.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 64,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma lista compartilhada',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sharedLists.length,
                itemBuilder: (context, index) {
                  final item = _sharedLists[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        Icons.share,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(item['name'] as String),
                      subtitle: Text(
                        'Compartilhado com: ${item['sharedWith']}\n${item['date']}',
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            child: Text('Editar Acesso'),
                          ),
                          const PopupMenuItem(
                            child: Text('Parar de Compartilhar'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 32),

            // Botão para compartilhar nova lista
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecione uma lista para compartilhar'),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Compartilhar Nova Lista'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
