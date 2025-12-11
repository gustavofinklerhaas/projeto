import 'package:flutter/material.dart';
import '../../core/data/preferences_service.dart';

/// Tela para visualizar e editar detalhes de uma lista de compras
class ListDetailsScreen extends StatefulWidget {
  final String listId;
  final String listName;

  const ListDetailsScreen({
    Key? key,
    required this.listId,
    required this.listName,
  }) : super(key: key);

  @override
  State<ListDetailsScreen> createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  late PreferencesService _preferencesService;
  Map<String, dynamic>? _list;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  final TextEditingController _itemController = TextEditingController();
  String? _selectedCategoryId;

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
        await _loadCategories();
        _loadList();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _preferencesService.getCategories();
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty && _selectedCategoryId == null) {
          _selectedCategoryId = _categories.first['id'];
        }
      });
    } catch (e) {
      // Erro ao carregar categorias
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  Future<void> _loadList() async {
    try {
      final list = await _preferencesService.getShoppingList(widget.listId);
      setState(() {
        _list = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addItem() async {
    if (_itemController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um item')),
      );
      return;
    }

    try {
      if (_list != null) {
        final items = List<dynamic>.from(_list!['items'] ?? []);
        items.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': _itemController.text,
          'checked': false,
          'quantity': 1,
          'categoryId': _selectedCategoryId,
        });

        await _preferencesService.updateShoppingList(
          widget.listId,
          {'items': items},
        );

        if (!mounted) return;
        _itemController.clear();
        _loadList();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item adicionado!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar item')),
      );
    }
  }

  Future<void> _toggleItem(String itemId, bool checked) async {
    try {
      if (_list != null) {
        final items = List<dynamic>.from(_list!['items'] ?? []);
        final itemIndex = items.indexWhere((i) => i['id'] == itemId);
        if (itemIndex != -1) {
          items[itemIndex]['checked'] = !checked;
          await _preferencesService.updateShoppingList(
            widget.listId,
            {'items': items},
          );
          if (!mounted) return;
          _loadList();
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar item')),
      );
    }
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      if (_list != null) {
        final items = List<dynamic>.from(_list!['items'] ?? []);
        items.removeWhere((i) => i['id'] == itemId);
        await _preferencesService.updateShoppingList(
          widget.listId,
          {'items': items},
        );
        if (!mounted) return;
        _loadList();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removido!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao remover item')),
      );
    }
  }

  Map<String, List<dynamic>> _groupItemsByCategory() {
    final items = (_list!['items'] as List<dynamic>?) ?? [];
    final grouped = <String, List<dynamic>>{};
    
    for (var item in items) {
      final categoryId = item['categoryId'] as String? ?? 'uncategorized';
      if (!grouped.containsKey(categoryId)) {
        grouped[categoryId] = [];
      }
      grouped[categoryId]!.add(item);
    }
    
    // Ordenar por ordem das categorias
    final sortedGrouped = <String, List<dynamic>>{};
    for (var category in _categories) {
      if (grouped.containsKey(category['id'])) {
        sortedGrouped[category['id']] = grouped[category['id']]!;
      }
    }
    
    // Adicionar itens sem categoria ao final
    if (grouped.containsKey('uncategorized')) {
      sortedGrouped['uncategorized'] = grouped['uncategorized']!;
    }
    
    return sortedGrouped;
  }

  Color _getCategoryColor(String? categoryId) {
    if (categoryId == null || categoryId == 'uncategorized') {
      return Colors.grey.withOpacity(0.3);
    }
    
    try {
      final category = _categories.firstWhere((c) => c['id'] == categoryId);
      final colorHex = category['colorHex'] as String;
      return Color(int.parse('0x$colorHex'));
    } catch (e) {
      return Colors.grey.withOpacity(0.3);
    }
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null || categoryId == 'uncategorized') {
      return 'Sem categoria';
    }
    
    try {
      final category = _categories.firstWhere((c) => c['id'] == categoryId);
      return category['name'] as String;
    } catch (e) {
      return 'Sem categoria';
    }
  }

  List<Widget> _buildCategoryGroups() {
    final groupedItems = _groupItemsByCategory();
    final widgets = <Widget>[];

    for (var categoryId in groupedItems.keys) {
      final items = groupedItems[categoryId]!;
      final categoryName = _getCategoryName(categoryId);
      final categoryColor = _getCategoryColor(categoryId);

      // Header da categoria
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: categoryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            categoryName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );

      // Items da categoria
      for (var item in items) {
        final itemId = item['id'] as String;
        final itemName = item['name'] as String;
        final isChecked = item['checked'] as bool? ?? false;

        widgets.add(
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Checkbox(
                value: isChecked,
                onChanged: (value) => _toggleItem(itemId, isChecked),
              ),
              title: Text(
                itemName,
                style: TextStyle(
                  decoration:
                      isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteItem(itemId),
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _list == null
              ? Center(
                  child: Text(
                    'Lista não encontrada',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ..._buildCategoryGroups(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categoria:',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: _selectedCategoryId,
                            isExpanded: true,
                            items: _categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category['id'] as String,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(category['id']),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(category['name'] as String),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategoryId = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _itemController,
                                  decoration: InputDecoration(
                                    hintText: 'Adicionar item...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(Icons.add_shopping_cart),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              FloatingActionButton(
                                onPressed: _addItem,
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
