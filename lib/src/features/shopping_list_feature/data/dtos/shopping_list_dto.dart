/// ShoppingListDto
/// 
/// DTO (Data Transfer Object) que representa uma lista de compras na camada de dados.
/// Segue os princípios de Clean Architecture:
/// - NÃO estende Entity (separação clara)
/// - Existe apenas na camada Data
/// - Responsável exclusivamente pela serialização/desserialização
/// - Espelha o formato de armazenamento (SharedPreferences/API)
class ShoppingListDto {
  final String id;
  final String name;
  final int createdAtMillis; // DateTime armazenado como milliseconds

  /// Construtor do DTO
  const ShoppingListDto({
    required this.id,
    required this.name,
    required this.createdAtMillis,
  });

  /// Factory constructor: Cria um DTO a partir de um Map
  /// 
  /// Usado para desserializar dados do SharedPreferences, banco de dados, API, etc.
  /// 
  /// Exemplo:
  ///   final data = {
  ///     'id': '1',
  ///     'name': 'Compras do mês',
  ///     'createdAtMillis': 1702300800000
  ///   };
  ///   final dto = ShoppingListDto.fromMap(data);
  factory ShoppingListDto.fromMap(Map<String, dynamic> map) {
    return ShoppingListDto(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      createdAtMillis: map['createdAtMillis'] as int? ?? 0,
    );
  }

  /// Converte o DTO para um Map
  /// 
  /// Usado para serializar dados para o SharedPreferences, banco de dados, API, etc.
  /// 
  /// Retorna:
  ///   Um Map com String como chave e valores dinâmicos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAtMillis': createdAtMillis,
    };
  }

  /// Cria uma cópia do DTO com campos opcionais modificados
  ShoppingListDto copyWith({
    String? id,
    String? name,
    int? createdAtMillis,
  }) {
    return ShoppingListDto(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          createdAtMillis == other.createdAtMillis;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAtMillis.hashCode;

  @override
  String toString() =>
      'ShoppingListDto(id: $id, name: $name, createdAtMillis: $createdAtMillis)';
}
