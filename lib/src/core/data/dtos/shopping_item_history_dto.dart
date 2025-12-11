/// DTO: ShoppingItemHistory
class ShoppingItemHistoryDto {
  final String id;
  final String itemId;
  final String listId;
  final String itemName;
  final double quantity;
  final String unit;
  final String purchasedAt;
  final double? costPerUnit;
  final String? storeId;

  ShoppingItemHistoryDto({
    required this.id,
    required this.itemId,
    required this.listId,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.purchasedAt,
    this.costPerUnit,
    this.storeId,
  });

  /// Serializa para JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'itemId': itemId,
        'listId': listId,
        'itemName': itemName,
        'quantity': quantity,
        'unit': unit,
        'purchasedAt': purchasedAt,
        'costPerUnit': costPerUnit,
        'storeId': storeId,
      };

  /// Desserializa de JSON
  factory ShoppingItemHistoryDto.fromJson(Map<String, dynamic> json) {
    return ShoppingItemHistoryDto(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      listId: json['listId'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      purchasedAt: json['purchasedAt'] as String,
      costPerUnit: json['costPerUnit'] != null ? (json['costPerUnit'] as num).toDouble() : null,
      storeId: json['storeId'] as String?,
    );
  }
}
