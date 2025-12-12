import 'package:flutter/material.dart';
import 'package:shopping_list/src/core/domain/entities/store.dart';
import 'package:shopping_list/src/features/store/presentation/widgets/store_list_item.dart';
import 'package:shopping_list/src/features/store/presentation/dialogs/store_actions_dialog.dart';
import 'package:shopping_list/src/features/store/presentation/dialogs/store_remove_confirmation_dialog.dart';
import 'package:shopping_list/src/features/store/presentation/dialogs/store_form_dialog.dart';
import 'package:shopping_list/src/features/store/presentation/dialogs/swipe_remove_confirmation_dialog.dart';

/// Página de listagem de lojas
/// 
/// Implementa a listagem conforme Prompt 8:
/// - Carregamento inicial (simulado)
/// - ListView.builder para renderizar itens
/// - Tratamento de estados (loading, vazio, erro)
/// - Integração com dados locais
class StoresPage extends StatefulWidget {
  const StoresPage({Key? key}) : super(key: key);

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  // Estado da página
  bool _isLoading = true;
  List<Store> _stores = [];
  String? _errorMessage;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMorePages = true;

  // Filtros
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carrega lojas do DAO local
  Future<void> _loadStores({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMorePages = true;
      });
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simula carregamento de dados
      // Em produção, chamar o DAO: _dao.listAll()
      await Future.delayed(const Duration(seconds: 1));

      // Dados mockados para demonstração
      final mockStores = [
        Store(
          id: '1',
          name: 'Supermercado ABC',
          address: 'Av. Paulista, 1000 - São Paulo, SP',
          latitude: -23.5505,
          longitude: -46.6333,
          phone: '(11) 3000-0000',
          website: 'www.supermercadoabc.com.br',
          acceptedPaymentMethods: ['cash', 'debit', 'credit'],
          averageRating: 4.7,
          reviewCount: 324,
          isFavorite: true,
        ),
        Store(
          id: '2',
          name: 'Farmácia São José',
          address: 'Rua 15 de Novembro, 500 - São Paulo, SP',
          latitude: -23.5600,
          longitude: -46.6400,
          phone: '(11) 3001-1111',
          website: null,
          acceptedPaymentMethods: ['cash', 'debit', 'credit', 'pix'],
          averageRating: 4.5,
          reviewCount: 156,
          isFavorite: false,
        ),
        Store(
          id: '3',
          name: 'Padaria Dom Bosco',
          address: 'Rua das Flores, 250 - São Paulo, SP',
          latitude: -23.5700,
          longitude: -46.6500,
          phone: '(11) 3002-2222',
          website: null,
          acceptedPaymentMethods: ['cash', 'debit'],
          averageRating: 4.3,
          reviewCount: 89,
          isFavorite: false,
        ),
        Store(
          id: '4',
          name: 'Shopping Center XYZ',
          address: 'Av. Brasil, 3000 - São Paulo, SP',
          latitude: -23.5800,
          longitude: -46.6600,
          phone: '(11) 3003-3333',
          website: 'www.shoppingxyz.com.br',
          acceptedPaymentMethods: ['cash', 'debit', 'credit', 'pix'],
          averageRating: 4.9,
          reviewCount: 523,
          isFavorite: false,
        ),
        Store(
          id: '5',
          name: 'Mercado da Zona Leste',
          address: 'Rua Tatuapé, 789 - São Paulo, SP',
          latitude: -23.5400,
          longitude: -46.5500,
          phone: '(11) 3004-4444',
          website: null,
          acceptedPaymentMethods: ['cash', 'debit', 'credit'],
          averageRating: 3.8,
          reviewCount: 42,
          isFavorite: false,
        ),
      ];

      setState(() {
        _stores = mockStores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar lojas: $e';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? ''),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Abre o diálogo de ações para uma loja selecionada
  void _showStoreActionsDialog(Store store) {
    StoreActionsDialog.show(
      context,
      store: store,
      onEdit: () => _handleEditStore(store),
      onRemove: () => _handleRemoveStore(store),
    );
  }

  /// Handler para edição de loja
  /// Abre formulário de edição pré-preenchido
  void _handleEditStore(Store store) {
    StoreFormDialog.show(
      context,
      store: store,
      onSave: (updatedStore) {
        _confirmEditStore(updatedStore);
      },
    );
  }

  /// Confirma e executa a edição de uma loja
  void _confirmEditStore(Store updatedStore) {
    try {
      setState(() {
        // Encontra e atualiza a loja na lista
        final index = _stores.indexWhere((s) => s.id == updatedStore.id);
        if (index != -1) {
          _stores[index] = updatedStore;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedStore.name} atualizada com sucesso'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      // TODO: Em produção, persistir no DAO
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar loja: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Handler para remoção de loja
  /// Abre diálogo de confirmação
  void _handleRemoveStore(Store store) {
    StoreRemoveConfirmationDialog.show(
      context,
      store: store,
      onConfirm: () => _confirmRemoveStore(store),
    );
  }

  /// Handler para remoção de loja por swipe
  void _handleSwipeRemoveStore(Store store) {
    _confirmRemoveStore(store);
  }

  /// Confirma e executa a remoção de uma loja
  void _confirmRemoveStore(Store store) {
    try {
      setState(() {
        _stores.removeWhere((s) => s.id == store.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${store.name} removida com sucesso'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      // TODO: Em produção, persistir no DAO
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover loja: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Filtra lojas baseado na busca
  List<Store> _getFilteredStores() {
    var filtered = _stores;

    // Aplicar filtro de busca
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((store) =>
              store.name.toLowerCase().contains(query) ||
              store.address.toLowerCase().contains(query))
          .toList();
    }

    // Aplicar ordenação
    filtered.sort((a, b) {
      late int comparison;

      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'rating':
          comparison = (a.averageRating ?? 0)
              .compareTo(b.averageRating ?? 0);
          break;
        case 'reviews':
          comparison = a.reviewCount.compareTo(b.reviewCount);
          break;
        default:
          comparison = 0;
      }

      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lojas'),
        elevation: 0,
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Container(
            color: Colors.blue[700],
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar loja...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Barra de filtros
          Container(
            color: Colors.blue[600],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Ordenação
                Expanded(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                        value: 'name',
                        child: const Text('Nome', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'rating',
                        child: const Text('Avaliação', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem(
                        value: 'reviews',
                        child: const Text('Resenhas', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _sortBy = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Direção de ordenação
                IconButton(
                  icon: Icon(
                    _sortAscending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _sortAscending = !_sortAscending;
                    });
                  },
                ),
              ],
            ),
          ),

          // Conteúdo principal
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  /// Constrói o conteúdo baseado no estado
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Erro desconhecido',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadStores,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final filteredStores = _getFilteredStores();

    if (filteredStores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma loja encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tente ajustar seus filtros',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: filteredStores.length,
      itemBuilder: (context, index) {
        final store = filteredStores[index];
        return Dismissible(
          key: ValueKey(store.id),
          direction: DismissDirection.endToStart,
          // Background durante swipe
          background: Container(
            color: Colors.red.withOpacity(0.8),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Remover',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Confirmação antes de remover
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              // Abre diálogo de confirmação
              final confirmed = await SwipeRemoveConfirmationDialog.show(
                context,
                itemName: store.name,
                onConfirm: () {
                  // Callback é executado antes de retornar
                },
              );
              
              if (confirmed == true) {
                // Usuário confirmou a remoção
                _handleSwipeRemoveStore(store);
              }
              
              return confirmed ?? false;
            }
            return false;
          },
          // Ação ao confirmar remoção
          onDismissed: (direction) {
            // A remoção já foi tratada em confirmDismiss
            // Este callback é apenas para limpeza se necessário
          },
          child: StoreListItem(
            store: store,
            onTap: () {
              _showStoreActionsDialog(store);
            },
            onEditTap: () {
              _handleEditStore(store);
            },
          ),
        );
      },
    );
  }
}
