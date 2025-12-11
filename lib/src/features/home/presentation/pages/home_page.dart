import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/features/home/presentation/controller/home_controller.dart';
import 'package:flutter_application_1/src/features/home/presentation/controller/home_state.dart';
import 'package:flutter_application_1/src/features/shopping_list/data/di/shopping_list_provider.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/get_all_items.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/add_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/remove_item.dart';
import 'package:flutter_application_1/src/features/shopping_list/domain/usecases/update_item.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/data/di/categories_provider.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/presentation/controller/categories_controller.dart';
import 'package:flutter_application_1/src/shared/enums/sort_mode.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _controller;
  late CategoriesController _categoriesController;
  bool _isInitialized = false;
  String? _selectedCategoryId;
  SortMode _currentSortMode = SortMode.nameAZ;

  @override
  void initState() {
    super.initState();
    _initializeControllerSync();
  }

  /// Inicializa o controller de forma síncrona no initState
  /// 
  /// Usa Future.microtask para garantir que o controller esteja pronto
  /// antes que build() seja chamado
  void _initializeControllerSync() {
    Future.microtask(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final repository = ShoppingListProvider.provideRepository(prefs);

        _controller = HomeController(
          getAllItems: GetAllItems(repository),
          addItem: AddItem(repository),
          removeItem: RemoveItem(repository),
          updateItem: UpdateItem(repository),
        );

        // Inicializar categorias controller
        final categoriesRepository = CategoriesProvider.provideRepository(prefs);
        final useCases = CategoriesProvider.provideUseCases(categoriesRepository);
        
        _categoriesController = CategoriesController(
          getAllCategories: useCases.getAllCategories,
          addCategory: useCases.addCategory,
          removeCategory: useCases.removeCategory,
          updateCategory: useCases.updateCategory,
        );

        if (mounted) {
          setState(() {
            _isInitialized = true;
          });

          // Carrega os itens e categorias após inicialização
          _controller.loadItems();
          _categoriesController.loadCategories();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    });
  }

  /// Abre um diálogo para adicionar um novo item
  void _showAddItemDialog() {
    final titleController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    String? selectedCategoryId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome do item',
                  hintText: 'Ex: Leite',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  hintText: '1',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: _categoriesController.state,
                builder: (context, state, _) {
                  if (state.categories.isEmpty) {
                    return const Text('Nenhuma categoria criada');
                  }
                  
                  return DropdownButtonFormField<String?>(
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Categoria (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Sem categoria'),
                      ),
                      ...state.categories.map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      selectedCategoryId = value;
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final quantity = int.tryParse(quantityController.text) ?? 1;

              if (title.isNotEmpty && quantity > 0) {
                _controller.addItem(title, quantity, categoryId: selectedCategoryId);
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
      _categoriesController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se ainda não foi inicializado, mostra loading
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lista de Compras',
            semanticsLabel: 'Página inicial - Lista de Compras',
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Compras',
          semanticsLabel: 'Página inicial - Lista de Compras',
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Tooltip(
            message: 'Gerenciar categorias',
            child: IconButton(
              icon: const Icon(Icons.category),
              onPressed: () {
                Navigator.pushNamed(context, '/categories');
              },
            ),
          ),
          Tooltip(
            message: 'Configurações',
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<HomeState>(
        valueListenable: _controller.state,
        builder: (context, state, _) {
          // Mostra indicador de carregamento
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)),
              ),
            );
          }

          // Itens filtrados pela categoria selecionada
          final filteredItems = _selectedCategoryId == null
              ? state.items
              : state.items
                  .where((item) => item.categoryId == _selectedCategoryId)
                  .toList();

          return Column(
            children: [
              // Filtro de categorias
              ValueListenableBuilder(
                valueListenable: _categoriesController.state,
                builder: (context, categoriesState, _) {
                  if (categoriesState.categories.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        // Chip "Todas"
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: const Text('Todas'),
                            selected: _selectedCategoryId == null,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategoryId = null;
                              });
                            },
                            selectedColor: const Color(0xFF6200EE),
                            labelStyle: TextStyle(
                              color: _selectedCategoryId == null
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        // Chips de categorias
                        ...categoriesState.categories.map(
                          (category) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              label: Text(category.name),
                              selected: _selectedCategoryId == category.id,
                              onSelected: (_) {
                                setState(() {
                                  _selectedCategoryId = category.id;
                                });
                              },
                              selectedColor: const Color(0xFF6200EE),
                              labelStyle: TextStyle(
                                color: _selectedCategoryId == category.id
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Dropdown de ordenação
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.sort, size: 20, color: Color(0xFF6200EE)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<SortMode>(
                        value: _currentSortMode,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: SortMode.values.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(mode.label),
                          );
                        }).toList(),
                        onChanged: (mode) {
                          if (mode != null) {
                            setState(() {
                              _currentSortMode = mode;
                            });
                            _controller.sortItems(mode);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de itens filtrados
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDDEFF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  '🛒',
                                  style: TextStyle(fontSize: 56),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Nenhum item',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: Colors.black87,
                                    fontSize: 24,
                                  ),
                              textAlign: TextAlign.center,
                              semanticsLabel: 'Nenhum item na sua lista de compras',
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Comece adicionando seus itens\ncom o botão + abaixo',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: item.isDone,
                                  activeColor: const Color(0xFF6200EE),
                                  onChanged: (value) {
                                    _controller.toggleDone(item.id);
                                  },
                                ),
                                title: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: item.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color:
                                        item.isDone ? Colors.grey : Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  'Quantidade: ${item.quantity}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _controller.removeItem(item.id);
                                  },
                                  tooltip: 'Remover item',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        tooltip: 'Adicionar novo item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
