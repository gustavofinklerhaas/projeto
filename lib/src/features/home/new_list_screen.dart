import 'package:flutter/material.dart';
import '../../core/data/preferences_service.dart';

/// Tela para criar uma nova lista de compras
class NewListScreen extends StatefulWidget {
  const NewListScreen({Key? key}) : super(key: key);

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  final TextEditingController _listNameController = TextEditingController();
  late PreferencesService _preferencesService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _preferencesService = PreferencesService();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    try {
      await _preferencesService.init();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao inicializar preferências')),
        );
      }
    }
  }

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }

  Future<void> _createList() async {
    if (_listNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um nome para a lista')),
      );
      return;
    }

    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferências não inicializadas')),
      );
      return;
    }

    try {
      await _preferencesService.createShoppingList(_listNameController.text);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lista "${_listNameController.text}" criada com sucesso!')),
      );

      // Simular navegação de volta
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao criar lista')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Lista'),
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
            Text(
              'Criar Nova Lista de Compras',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Semantics(
              label: 'Campo de entrada para nome da lista',
              textField: true,
              enabled: true,
              child: TextField(
                controller: _listNameController,
                decoration: InputDecoration(
                  hintText: 'Ex: Supermercado, Padaria...',
                  labelText: 'Nome da Lista',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.shopping_cart),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _createList,
                icon: const Icon(Icons.add),
                label: const Text('Criar Lista'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
