/// ShoppingItemCategory Entity
/// 
/// Entidade que representa uma categoria de item de compras.
/// Segue os princípios de Clean Architecture:
/// - Imutável (final fields)
/// - Independente de camadas inferiores
/// - Sem dependências de DTO ou Model
/// - Contém apenas a lógica de negócios essencial
class ShoppingItemCategory {
  final String id;
  final String name;
  final String colorHex;

  /// Construtor da entidade ShoppingItemCategory
  /// 
  /// Parâmetros:
  ///   - id: Identificador único da categoria
  ///   - name: Nome da categoria (ex: "Frutas", "Lácteos")
  ///   - colorHex: Cor em hexadecimal sem '#' (ex: "FF6200EE")
  const ShoppingItemCategory({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  /// Cria uma cópia da categoria com campos opcionais modificados
  /// 
  /// Útil para atualizar apenas alguns campos sem criar uma nova instância
  /// do zero. Segue o padrão de imutabilidade funcional.
  ShoppingItemCategory copyWith({
    String? id,
    String? name,
    String? colorHex,
  }) {
    return ShoppingItemCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItemCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          colorHex == other.colorHex;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ colorHex.hashCode;

  @override
  String toString() =>
      'ShoppingItemCategory(id: $id, name: $name, colorHex: $colorHex)';
}
