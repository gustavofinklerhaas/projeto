/// ShoppingItem Entity
/// 
/// Entidade que representa um item de compras na camada de domínio.
/// Segue os princípios de Clean Architecture:
/// - Imutável (final fields)
/// - Independente de camadas inferiores
/// - Sem dependências de DTO ou Model
/// - Contém apenas a lógica de negócios essencial
class ShoppingItem {
  final String id;
  final String title;
  final int quantity;
  final bool isDone;
  final String? categoryId;
  final DateTime createdAt;

  /// Construtor da entidade ShoppingItem
  /// 
  /// Parâmetros:
  ///   - id: Identificador único do item
  ///   - title: Nome/descrição do item
  ///   - quantity: Quantidade do item
  ///   - isDone: Indica se o item foi concluído/comprado
  ///   - categoryId: ID da categoria associada (opcional)
  ///   - createdAt: Data de criação do item (padrão: 2024-01-01)
  ShoppingItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.isDone,
    this.categoryId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime(2024, 1, 1);

  /// Cria uma cópia do item com campos opcionais modificados
  /// 
  /// Útil para atualizar apenas alguns campos sem criar uma nova instância
  /// do zero. Segue o padrão de imutabilidade funcional.
  ShoppingItem copyWith({
    String? id,
    String? title,
    int? quantity,
    bool? isDone,
    String? categoryId,
    DateTime? createdAt,
  }) {
    return ShoppingItem(
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
      other is ShoppingItem &&
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
      'ShoppingItem(id: $id, title: $title, quantity: $quantity, isDone: $isDone, categoryId: $categoryId, createdAt: $createdAt)';
}
