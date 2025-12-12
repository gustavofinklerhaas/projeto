import 'package:flutter/material.dart';
import 'package:shopping_list/src/core/domain/entities/store.dart';

/// Widget que renderiza um item da lista de lojas
class StoreListItem extends StatelessWidget {
  final Store store;
  final VoidCallback onTap;
  final VoidCallback? onEditTap; // Novo callback para edição

  const StoreListItem({
    Key? key,
    required this.store,
    required this.onTap,
    this.onEditTap,
  }) : super(key: key);

  /// Formata rating com uma casa decimal
  String _formatRating(double? rating) {
    if (rating == null) return 'Sem avaliação';
    return rating.toStringAsFixed(1);
  }

  /// Retorna cor baseada no rating
  Color _getRatingColor(double? rating) {
    if (rating == null) return Colors.grey;
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.lightGreen;
    if (rating >= 3.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome, status favorito e ícone de edição
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            store.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (store.isFavorite)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Ícone de edição
                  if (onEditTap != null)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEditTap,
                      tooltip: 'Editar loja',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Endereço
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      store.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Rating, Reviews e Payment Methods
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRatingColor(store.averageRating)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _getRatingColor(store.averageRating),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: _getRatingColor(store.averageRating),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatRating(store.averageRating),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getRatingColor(store.averageRating),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Review Count
                  Text(
                    '${store.reviewCount} avaliações',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  // Payment Methods
                  Tooltip(
                    message: store.acceptedPaymentMethods.join(', '),
                    child: const Icon(
                      Icons.payment,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
