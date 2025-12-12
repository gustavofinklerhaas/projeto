import 'package:flutter/material.dart';
import 'package:shopping_list/src/core/domain/entities/store.dart';

/// Diálogo de confirmação para remoção de uma loja
/// 
/// Pede confirmação antes de remover um item da lista
/// Não é dismissável ao tocar fora (barrierDismissible: false)
class StoreRemoveConfirmationDialog extends StatelessWidget {
  final Store store;
  final VoidCallback onConfirm;

  const StoreRemoveConfirmationDialog({
    Key? key,
    required this.store,
    required this.onConfirm,
  }) : super(key: key);

  /// Abre o diálogo de confirmação de remoção
  static Future<void> show(
    BuildContext context, {
    required Store store,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Não fecha ao tocar fora
      builder: (context) => StoreRemoveConfirmationDialog(
        store: store,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '⚠️ Remover loja?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                const TextSpan(
                  text: 'Você tem certeza que deseja remover ',
                ),
                TextSpan(
                  text: store.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' da sua lista de lojas?',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Esta ação não pode ser desfeita.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        // Botão CANCELAR
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey),
          ),
        ),

        // Botão REMOVER (com cor de aviso)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Remover'),
        ),
      ],
    );
  }
}
