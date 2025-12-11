/// ShoppingList Entity
/// 
/// Entidade que representa uma lista de compras.
/// Segue os princípios de Clean Architecture:
/// - Imutável (final fields)
/// - Independente de camadas inferiores
/// - Sem dependências de DTO ou Model
/// - Contém apenas a lógica de negócios essencial
class ShoppingList {
  final String id;
  final String name;
  final DateTime createdAt;

  /// Construtor da entidade ShoppingList
  /// 
  /// Parâmetros:
  ///   - id: Identificador único da lista
  ///   - name: Nome descritivo da lista (ex: "Compras do mês")
  ///   - createdAt: Data e hora de criação da lista
  const ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  /// Cria uma cópia da lista com campos opcionais modificados
  /// 
  /// Útil para atualizar apenas alguns campos sem criar uma nova instância
  /// do zero. Segue o padrão de imutabilidade funcional.
  ShoppingList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingList &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode;

  @override
  String toString() =>
      'ShoppingList(id: $id, name: $name, createdAt: $createdAt)';
}
