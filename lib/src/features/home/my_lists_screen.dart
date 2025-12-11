import 'package:flutter/material.dart';
import '../../core/data/preferences_service.dart';
import 'list_details_screen.dart';

/// Tela para exibir todas as listas de compras
class MyListsScreen extends StatefulWidget {
  const MyListsScreen({Key? key}) : super(key: key);

  @override
  State<MyListsScreen> createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen> {
  late PreferencesService _preferencesService;
  List<Map<String, dynamic>> _lists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _preferencesService = PreferencesService();
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    try {
      await _preferencesService.init();
      if (mounted) {
        _loadLists();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLists() async {
    try {
      final lists = await _preferencesService.getShoppingLists();
      setState(() {
        _lists = lists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openList(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListDetailsScreen(
          listId: _lists[index]['id'],
          listName: _lists[index]['name'],
        ),
      ),
    ).then((_) {
      // Recarrega listas ao voltar
      _loadLists();
    });
  }

  Future<void> _editList(int index) async {
    final list = _lists[index];
    final controller = TextEditingController(text: list['name']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Lista'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nome da lista',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _preferencesService.updateShoppingList(
                  list['id'],
                  {'name': controller.text},
                );
                if (!mounted) return;
                Navigator.pop(context);
                _loadLists();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lista editada com sucesso!')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao editar lista')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _duplicateList(int index) async {
    final list = _lists[index];
    try {
      await _preferencesService.createShoppingList('${list['name']} (Cópia)');
      _loadLists();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lista "${list['name']}" duplicada com sucesso!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao duplicar lista')),
      );
    }
  }

  Future<void> _deleteList(int index) async {
    final list = _lists[index];
    final listName = list['name'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Lista'),
        content: Text('Tem certeza que deseja deletar a lista "$listName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _preferencesService.deleteShoppingList(list['id']);
                if (!mounted) return;
                Navigator.pop(context);
                _loadLists();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lista "$listName" deletada!')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao deletar lista')),
                );
              }
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Listas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lists.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 64,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma lista criada',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Crie sua primeira lista para começar',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _lists.length,
                  itemBuilder: (context, index) {
                    final list = _lists[index];
                    final itemsCount = (list['items'] as List<dynamic>?)?.length ?? 0;
                    final createdDate = list['createdAt'] != null
                        ? DateTime.parse(list['createdAt']).toLocal()
                        : DateTime.now();
                    final dateStr =
                        '${createdDate.day}/${createdDate.month}/${createdDate.year}';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_bag,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(list['name'] as String),
                        subtitle: Text('$itemsCount itens • $dateStr'),
                        onTap: () => _openList(index),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            switch (value) {
                              case 'editar':
                                _editList(index);
                                break;
                              case 'duplicar':
                                _duplicateList(index);
                                break;
                              case 'deletar':
                                _deleteList(index);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'editar',
                              child: Text('Editar'),
                            ),
                            const PopupMenuItem(
                              value: 'duplicar',
                              child: Text('Duplicar'),
                            ),
                            const PopupMenuItem(
                              value: 'deletar',
                              child: Text('Deletar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          // Vai voltar para Home e o usuário pode clicar em "Nova Lista"
        },
        tooltip: 'Criar nova lista',
        child: const Icon(Icons.add),
      ),
    );
  }
}
