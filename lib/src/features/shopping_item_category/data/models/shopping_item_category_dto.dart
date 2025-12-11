/// ShoppingItemCategoryDto
///
/// DTO (Data Transfer Object) que representa uma categoria na camada de dados.
/// NÃO estende Entity (separação clara).
class ShoppingItemCategoryDto {
  final String id;
  final String name;
  final String colorHex;

  const ShoppingItemCategoryDto({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  factory ShoppingItemCategoryDto.fromMap(Map<String, dynamic> map) {
    return ShoppingItemCategoryDto(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      colorHex: map['colorHex'] as String? ?? '#000000',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
    };
  }

  ShoppingItemCategoryDto copyWith({
    String? id,
    String? name,
    String? colorHex,
  }) {
    return ShoppingItemCategoryDto(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItemCategoryDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          colorHex == other.colorHex;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ colorHex.hashCode;

  @override
  String toString() =>
      'ShoppingItemCategoryDto(id: $id, name: $name, colorHex: $colorHex)';
}
