import 'package:uuid/uuid.dart';

/// Entity: Compartilhamento de lista entre usuários
class ShoppingListShare {
  final String id;
  final String shoppingListId;
  final String ownerId;
  final String sharedWithUserId;
  final SharePermission permission;
  final DateTime sharedAt;
  final DateTime? acceptedAt;
  final bool isActive;

  ShoppingListShare({
    String? id,
    required this.shoppingListId,
    required this.ownerId,
    required this.sharedWithUserId,
    this.permission = SharePermission.view,
    DateTime? sharedAt,
    this.acceptedAt,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        sharedAt = sharedAt ?? DateTime.now();

  /// Serializa para JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'shoppingListId': shoppingListId,
        'ownerId': ownerId,
        'sharedWithUserId': sharedWithUserId,
        'permission': permission.toString(),
        'sharedAt': sharedAt.toIso8601String(),
        'acceptedAt': acceptedAt?.toIso8601String(),
        'isActive': isActive,
      };

  /// Desserializa de JSON
  factory ShoppingListShare.fromJson(Map<String, dynamic> json) {
    return ShoppingListShare(
      id: json['id'] as String?,
      shoppingListId: json['shoppingListId'] as String,
      ownerId: json['ownerId'] as String,
      sharedWithUserId: json['sharedWithUserId'] as String,
      permission: _parsePermission(json['permission'] as String? ?? 'view'),
      sharedAt: json['sharedAt'] != null
          ? DateTime.parse(json['sharedAt'] as String)
          : null,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Cópia com mudanças
  ShoppingListShare copyWith({
    String? id,
    String? shoppingListId,
    String? ownerId,
    String? sharedWithUserId,
    SharePermission? permission,
    DateTime? sharedAt,
    DateTime? acceptedAt,
    bool? isActive,
  }) {
    return ShoppingListShare(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      ownerId: ownerId ?? this.ownerId,
      sharedWithUserId: sharedWithUserId ?? this.sharedWithUserId,
      permission: permission ?? this.permission,
      sharedAt: sharedAt ?? this.sharedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Verifica se o compartilhamento foi aceito
  bool get isAccepted => acceptedAt != null;

  @override
  String toString() =>
      'ShoppingListShare(id: $id, listId: $shoppingListId, permission: $permission)';
}

/// Enum: Permissões de compartilhamento
enum SharePermission {
  view,      // Apenas visualizar
  edit,      // Visualizar e editar
  admin,     // Controle total
}

SharePermission _parsePermission(String value) {
  switch (value.toLowerCase()) {
    case 'view':
      return SharePermission.view;
    case 'edit':
      return SharePermission.edit;
    case 'admin':
      return SharePermission.admin;
    default:
      return SharePermission.view;
  }
}
