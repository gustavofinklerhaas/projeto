import 'package:flutter/material.dart';
import 'package:shopping_list/src/core/domain/entities/store.dart';

/// Diálogo de ações para um item de loja selecionado
/// 
/// Apresenta três opções: EDITAR, REMOVER, FECHAR
/// Não é dismissável ao tocar fora (barrierDismissible: false)
class StoreActionsDialog extends StatelessWidget {
  final Store store;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const StoreActionsDialog({
    Key? key,
    required this.store,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  /// Abre o diálogo de ações para uma loja
  static Future<void> show(
    BuildContext context, {
    required Store store,
    required VoidCallback onEdit,
    required VoidCallback onRemove,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Não fecha ao tocar fora
      builder: (context) => StoreActionsDialog(
        store: store,
        onEdit: onEdit,
        onRemove: onRemove,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        store.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Endereço
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  store.address,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating e Reviews
          Row(
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: _getRatingColor(store.averageRating),
              ),
              const SizedBox(width: 4),
              Text(
                '${store.averageRating?.toStringAsFixed(1) ?? "N/A"} '
                '(${store.reviewCount} avaliações)',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Métodos de pagamento
          Wrap(
            spacing: 4,
            children: store.acceptedPaymentMethods
                .map((method) => Chip(
                      label: Text(
                        method,
                        style: const TextStyle(fontSize: 11),
                      ),
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
        ],
      ),
      actions: [
        // Botão FECHAR
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Fechar',
            style: TextStyle(color: Colors.grey),
          ),
        ),

        // Botão REMOVER (com cor de aviso)
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onRemove();
          },
          child: const Text(
            'Remover',
            style: TextStyle(color: Colors.red),
          ),
        ),

        // Botão EDITAR (com destaque)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onEdit();
          },
          child: const Text('Editar'),
        ),
      ],
    );
  }

  /// Retorna cor baseada no rating
  Color _getRatingColor(double? rating) {
    if (rating == null) return Colors.grey;
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.lightGreen;
    if (rating >= 3.0) return Colors.orange;
    return Colors.red;
  }
}
