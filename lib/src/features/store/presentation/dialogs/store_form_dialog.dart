import 'package:flutter/material.dart';
import 'package:shopping_list/src/core/domain/entities/store.dart';

/// Diálogo de formulário para edição/criação de lojas
/// 
/// Apresenta campos editáveis para os dados da loja
/// Não é dismissável ao tocar fora (barrierDismissible: false)
class StoreFormDialog extends StatefulWidget {
  final Store? store; // null para criação, preenchido para edição
  final Function(Store) onSave;

  const StoreFormDialog({
    Key? key,
    this.store,
    required this.onSave,
  }) : super(key: key);

  /// Abre o diálogo de edição/criação de loja
  static Future<void> show(
    BuildContext context, {
    Store? store,
    required Function(Store) onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Não fecha ao tocar fora
      builder: (context) => StoreFormDialog(
        store: store,
        onSave: onSave,
      ),
    );
  }

  @override
  State<StoreFormDialog> createState() => _StoreFormDialogState();
}

class _StoreFormDialogState extends State<StoreFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _ratingController;
  late TextEditingController _reviewCountController;

  late List<String> _paymentMethods;
  bool _isFavorite = false;
  bool _isLoading = false;
  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.store != null) {
      // Modo edição: preencher com dados existentes
      _nameController = TextEditingController(text: widget.store!.name);
      _addressController = TextEditingController(text: widget.store!.address);
      _phoneController = TextEditingController(text: widget.store!.phone);
      _websiteController = TextEditingController(text: widget.store!.website);
      _latitudeController =
          TextEditingController(text: widget.store!.latitude.toString());
      _longitudeController =
          TextEditingController(text: widget.store!.longitude.toString());
      _ratingController = TextEditingController(
        text: widget.store!.averageRating?.toStringAsFixed(1),
      );
      _reviewCountController =
          TextEditingController(text: widget.store!.reviewCount.toString());
      _paymentMethods = List.from(widget.store!.acceptedPaymentMethods);
      _isFavorite = widget.store!.isFavorite;
    } else {
      // Modo criação: campos vazios
      _nameController = TextEditingController();
      _addressController = TextEditingController();
      _phoneController = TextEditingController();
      _websiteController = TextEditingController();
      _latitudeController = TextEditingController();
      _longitudeController = TextEditingController();
      _ratingController = TextEditingController();
      _reviewCountController = TextEditingController(text: '0');
      _paymentMethods = ['cash', 'debit', 'credit'];
      _isFavorite = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _ratingController.dispose();
    _reviewCountController.dispose();
    super.dispose();
  }

  /// Valida e salva o formulário
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Parse dos valores
      final latitude = double.tryParse(_latitudeController.text) ?? 0.0;
      final longitude = double.tryParse(_longitudeController.text) ?? 0.0;
      final rating = double.tryParse(_ratingController.text);
      final reviewCount = int.tryParse(_reviewCountController.text) ?? 0;

      // Criar ou atualizar Store
      final updatedStore = Store(
        id: widget.store?.id,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        latitude: latitude,
        longitude: longitude,
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        acceptedPaymentMethods: _paymentMethods,
        averageRating: rating,
        reviewCount: reviewCount,
        isFavorite: _isFavorite,
        createdAt: widget.store?.createdAt,
      );

      // Simular delay de persistência
      await Future.delayed(const Duration(milliseconds: 500));

      // Chamar callback
      widget.onSave(updatedStore);

      // Fechar diálogo
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao salvar: $e';
        _isLoading = false;
      });
    }
  }

  /// Toggle para método de pagamento
  void _togglePaymentMethod(String method) {
    setState(() {
      if (_paymentMethods.contains(method)) {
        _paymentMethods.remove(method);
      } else {
        _paymentMethods.add(method);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.store != null;
    final title = isEditMode ? 'Editar Loja' : 'Criar Loja';

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mensagem de erro
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Nome da loja
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da loja *',
                  prefixIcon: Icon(Icons.store),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Endereço
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Endereço *',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Endereço é obrigatório';
                  }
                  return null;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Latitude e Longitude (lado a lado)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude *',
                        prefixIcon: Icon(Icons.language),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Requerido';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude *',
                        prefixIcon: Icon(Icons.language),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Requerido';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Telefone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Website
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website',
                  prefixIcon: Icon(Icons.public),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Rating
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  labelText: 'Avaliação (0-5)',
                  prefixIcon: Icon(Icons.star),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Review Count
              TextFormField(
                controller: _reviewCountController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade de Avaliações',
                  prefixIcon: Icon(Icons.reviews),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Métodos de Pagamento
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Métodos de Pagamento:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      'cash',
                      'debit',
                      'credit',
                      'pix',
                    ]
                        .map((method) => FilterChip(
                              label: Text(method),
                              selected: _paymentMethods.contains(method),
                              onSelected: (selected) {
                                _togglePaymentMethod(method);
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Favorito
              CheckboxListTile(
                value: _isFavorite,
                onChanged: (value) {
                  setState(() {
                    _isFavorite = value ?? false;
                  });
                },
                title: const Text('Marcar como favorito'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Botão Cancelar
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text('Cancelar'),
        ),

        // Botão Salvar
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: _isLoading ? null : _saveForm,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}
