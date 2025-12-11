import 'package:flutter/material.dart';
import '../../core/data/preferences_service.dart';

/// Tela para gerenciar categorias de itens
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late PreferencesService _preferencesService;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  final TextEditingController _categoryController = TextEditingController();

  // Cores disponíveis para categorias
  final List<String> _availableColors = [
    'FF66BB6A', // Verde
    'FFAB47BC', // Roxo
    'FFEF5350', // Vermelho
    'FF29B6F6', // Azul
    'FFFFA726', // Laranja
    'FFEC407A', // Rosa
    'FF78909C', // Cinza
    'FFBDBDBD', // Cinza claro
  ];

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
        _loadCategories();
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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addCategory(String colorHex) async {
    if (_categoryController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um nome para a categoria')),
      );
      return;
    }

    try {
      await _preferencesService.createCategory(
        _categoryController.text,
        colorHex,
      );
      if (!mounted) return;
      _categoryController.clear();
      _loadCategories();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoria adicionada com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar categoria')),
      );
    }
  }

  void _showAddDialog() {
    String selectedColor = _availableColors[0];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Categoria'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    hintText: 'Nome da categoria',
                    labelText: 'Categoria',
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cor:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0x$color')),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _categoryController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _addCategory(selectedColor),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _editCategory(int index, String categoryId) {
    _categoryController.text = _categories[index]['name'];
    String selectedColor = _categories[index]['colorHex'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Categoria'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    hintText: 'Nome da categoria',
                    labelText: 'Categoria',
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cor:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0x$color')),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _categoryController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_categoryController.text.isEmpty) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Digite um nome para a categoria'),
                  ),
                );
                return;
              }

              try {
                await _preferencesService.updateCategory(
                  categoryId,
                  {
                    'name': _categoryController.text,
                    'colorHex': selectedColor,
                  },
                );
                if (!mounted) return;
                _categoryController.clear();
                _loadCategories();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Categoria editada com sucesso!')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao editar categoria')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int index, String categoryId) {
    final categoryName = _categories[index]['name'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Categoria'),
        content: Text(
          'Tem certeza que deseja deletar a categoria "$categoryName"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _preferencesService.deleteCategory(categoryId);
                if (!mounted) return;
                _loadCategories();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Categoria "$categoryName" deletada!'),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao deletar categoria')),
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
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final categoryId = category['id'] as String;
                final categoryName = category['name'] as String;
                final colorHex = category['colorHex'] as String;
                final color = Color(int.parse('0x$colorHex'));

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    title: Text(categoryName),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 'editar':
                            _editCategory(index, categoryId);
                            break;
                          case 'deletar':
                            _deleteCategory(index, categoryId);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'editar',
                          child: Text('Editar'),
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
        onPressed: _showAddDialog,
        tooltip: 'Adicionar categoria',
        child: const Icon(Icons.add),
      ),
    );
  }
}
