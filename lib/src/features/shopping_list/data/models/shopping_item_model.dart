/// ShoppingItemModel
/// 
/// DTO (Data Transfer Object) que representa um item de compras na camada de dados.
/// Segue os princípios de Clean Architecture:
/// - NÃO estende Entity (separação clara)
/// - Existe apenas na camada Data
/// - Responsável exclusivamente pela serialização/desserialização
/// - Espelha o formato de armazenamento (SharedPreferences/API)
/// 
/// IMPORTANTE: Este não herda de ShoppingItem. Use ShoppingItemMapper para conversão.
class ShoppingItemModel {
  final String id;
  final String title;
  final int quantity;
  final bool isDone;
  final String? categoryId;
  final String? createdAt; // ISO 8601 format

  /// Construtor do modelo
  const ShoppingItemModel({
    required this.id,
    required this.title,
    required this.quantity,
    required this.isDone,
    this.categoryId,
    this.createdAt,
  });

  /// Factory constructor: Cria um modelo a partir de um Map
  /// 
  /// Usado para desserializar dados do SharedPreferences, banco de dados, etc.
  /// 
  /// Exemplo:
  ///   final data = {
  ///     'id': '1',
  ///     'title': 'Leite',
  ///     'quantity': 2,
  ///     'isDone': false
  ///   };
  ///   final model = ShoppingItemModel.fromMap(data);
  factory ShoppingItemModel.fromMap(Map<String, dynamic> map) {
    return ShoppingItemModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      isDone: map['isDone'] as bool? ?? false,
      categoryId: map['categoryId'] as String?,
      createdAt: map['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  /// Converte o modelo para um Map
  /// 
  /// Usado para serializar dados para o SharedPreferences, banco de dados, etc.
  /// 
  /// Retorna:
  ///   Um Map com String como chave e valores dinâmicos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'isDone': isDone,
      'categoryId': categoryId,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Cria uma cópia do modelo com campos opcionais modificados
  ShoppingItemModel copyWith({
    String? id,
    String? title,
    int? quantity,
    bool? isDone,
    String? categoryId,
    String? createdAt,
  }) {
    return ShoppingItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      isDone: isDone ?? this.isDone,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          quantity == other.quantity &&
          isDone == other.isDone &&
          categoryId == other.categoryId &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ quantity.hashCode ^ isDone.hashCode ^ categoryId.hashCode ^ createdAt.hashCode;

  @override
  String toString() =>
      'ShoppingItemModel(id: $id, title: $title, quantity: $quantity, isDone: $isDone, categoryId: $categoryId, createdAt: $createdAt)';
}
