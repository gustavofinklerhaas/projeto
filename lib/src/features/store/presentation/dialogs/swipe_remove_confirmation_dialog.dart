import 'package:flutter/material.dart';

/// Diálogo de confirmação para remoção via swipe
/// 
/// Apresenta confirmação clara antes de remover
/// Não é dismissável ao tocar fora (barrierDismissible: false)
class SwipeRemoveConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;

  const SwipeRemoveConfirmationDialog({
    Key? key,
    required this.itemName,
    required this.onConfirm,
  }) : super(key: key);

  /// Abre o diálogo de confirmação para remoção por swipe
  static Future<bool?> show(
    BuildContext context, {
    required String itemName,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Não fecha ao tocar fora
      builder: (context) => SwipeRemoveConfirmationDialog(
        itemName: itemName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '⚠️ Remover item?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            const TextSpan(
              text: 'Você tem certeza que deseja remover ',
            ),
            TextSpan(
              text: itemName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(
              text: '?',
            ),
          ],
        ),
      ),
      actions: [
        // Botão Cancelar
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey),
          ),
        ),

        // Botão Remover
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          child: const Text('Remover'),
        ),
      ],
    );
  }
}
