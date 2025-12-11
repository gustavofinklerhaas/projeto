/// DTO: ShoppingListShare
class ShoppingListShareDto {
  final String id;
  final String shoppingListId;
  final String ownerId;
  final String sharedWithUserId;
  final String permission;
  final String sharedAt;
  final String? acceptedAt;
  final bool isActive;

  ShoppingListShareDto({
    required this.id,
    required this.shoppingListId,
    required this.ownerId,
    required this.sharedWithUserId,
    required this.permission,
    required this.sharedAt,
    this.acceptedAt,
    required this.isActive,
  });

  /// Serializa para JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'shoppingListId': shoppingListId,
        'ownerId': ownerId,
        'sharedWithUserId': sharedWithUserId,
        'permission': permission,
        'sharedAt': sharedAt,
        'acceptedAt': acceptedAt,
        'isActive': isActive,
      };

  /// Desserializa de JSON
  factory ShoppingListShareDto.fromJson(Map<String, dynamic> json) {
    return ShoppingListShareDto(
      id: json['id'] as String,
      shoppingListId: json['shoppingListId'] as String,
      ownerId: json['ownerId'] as String,
      sharedWithUserId: json['sharedWithUserId'] as String,
      permission: json['permission'] as String,
      sharedAt: json['sharedAt'] as String,
      acceptedAt: json['acceptedAt'] as String?,
      isActive: json['isActive'] as bool,
    );
  }
}
