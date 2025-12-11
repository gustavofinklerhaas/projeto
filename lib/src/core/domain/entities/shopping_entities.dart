import 'package:uuid/uuid.dart';

/// Modelo de uma Lista de Compras
class ShoppingList {
  final String id;
  final String name;
  final String description;
  final List<ShoppingItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;

  ShoppingList({
    String? id,
    required this.name,
    this.description = '',
    this.items = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isCompleted = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Converte para JSON para persistência
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Cria objeto a partir de JSON
  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ShoppingItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isCompleted: json['completed'] as bool? ?? false,
    );
  }

  /// Cria cópia com mudanças
  ShoppingList copyWith({
    String? id,
    String? name,
    String? description,
    List<ShoppingItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Modelo de um Item de Compra
class ShoppingItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final String? categoryId;
  final bool isPurchased;
  final DateTime createdAt;
  final DateTime? purchasedAt;

  ShoppingItem({
    String? id,
    required this.name,
    this.quantity = 1.0,
    this.unit = '',
    this.categoryId,
    this.isPurchased = false,
    DateTime? createdAt,
    this.purchasedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Converte para JSON para persistência
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'categoryId': categoryId,
      'isPurchased': isPurchased,
      'createdAt': createdAt.toIso8601String(),
      'purchasedAt': purchasedAt?.toIso8601String(),
    };
  }

  /// Cria objeto a partir de JSON
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] as String? ?? 'unidade',
      categoryId: json['categoryId'] as String,
      isPurchased: json['isPurchased'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'] as String)
          : null,
    );
  }

  /// Cria cópia com mudanças
  ShoppingItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    String? categoryId,
    bool? isPurchased,
    DateTime? createdAt,
    DateTime? purchasedAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      categoryId: categoryId ?? this.categoryId,
      isPurchased: isPurchased ?? this.isPurchased,
      createdAt: createdAt ?? this.createdAt,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }
}

/// Modelo de uma Categoria
class Category {
  final String id;
  final String name;
  final String colorHex;

  Category({
    String? id,
    required this.name,
    this.colorHex = '#2196F3',
  }) : id = id ?? const Uuid().v4();

  /// Converte para JSON para persistência
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
    };
  }

  /// Cria objeto a partir de JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      colorHex: json['colorHex'] as String,
    );
  }

  /// Cria cópia com mudanças
  Category copyWith({
    String? id,
    String? name,
    String? colorHex,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}
