import 'package:uuid/uuid.dart';

/// Entity: Histórico de compras de itens
class ShoppingItemHistory {
  final String id;
  final String itemId;
  final String listId;
  final String itemName;
  final double quantity;
  final String unit;
  final DateTime purchasedAt;
  final double? costPerUnit;
  final String? storeId;

  ShoppingItemHistory({
    String? id,
    required this.itemId,
    required this.listId,
    required this.itemName,
    required this.quantity,
    required this.unit,
    DateTime? purchasedAt,
    this.costPerUnit,
    this.storeId,
  })  : id = id ?? const Uuid().v4(),
        purchasedAt = purchasedAt ?? DateTime.now();

  /// Serializa para JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'itemId': itemId,
        'listId': listId,
        'itemName': itemName,
        'quantity': quantity,
        'unit': unit,
        'purchasedAt': purchasedAt.toIso8601String(),
        'costPerUnit': costPerUnit,
        'storeId': storeId,
      };

  /// Desserializa de JSON
  factory ShoppingItemHistory.fromJson(Map<String, dynamic> json) {
    return ShoppingItemHistory(
      id: json['id'] as String?,
      itemId: json['itemId'] as String,
      listId: json['listId'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] as String? ?? '',
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'] as String)
          : null,
      costPerUnit: (json['costPerUnit'] as num?)?.toDouble(),
      storeId: json['storeId'] as String?,
    );
  }

  /// Cópia com mudanças
  ShoppingItemHistory copyWith({
    String? id,
    String? itemId,
    String? listId,
    String? itemName,
    double? quantity,
    String? unit,
    DateTime? purchasedAt,
    double? costPerUnit,
    String? storeId,
  }) {
    return ShoppingItemHistory(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      listId: listId ?? this.listId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      storeId: storeId ?? this.storeId,
    );
  }

  /// Calcula o custo total do item
  double? get totalCost {
    if (costPerUnit == null) return null;
    return costPerUnit! * quantity;
  }

  @override
  String toString() =>
      'ShoppingItemHistory(id: $id, item: $itemName, qty: $quantity)';
}
