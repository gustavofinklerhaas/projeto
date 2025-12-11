/// StoreDto
/// 
/// DTO (Data Transfer Object) que representa uma loja na camada de dados.
/// Segue os princípios de Clean Architecture:
/// - NÃO estende Entity (separação clara)
/// - Existe apenas na camada Data
/// - Responsável exclusivamente pela serialização/desserialização
/// - Espelha o formato de armazenamento (SharedPreferences/API)
class StoreDto {
  final String id;
  final String name;
  final String? address;

  /// Construtor do DTO
  const StoreDto({
    required this.id,
    required this.name,
    this.address,
  });

  /// Factory constructor: Cria um DTO a partir de um Map
  /// 
  /// Usado para desserializar dados do SharedPreferences, banco de dados, API, etc.
  /// 
  /// Exemplo:
  ///   final data = {
  ///     'id': '1',
  ///     'name': 'Supermercado ABC',
  ///     'address': 'Rua 123, São Paulo'
  ///   };
  ///   final dto = StoreDto.fromMap(data);
  factory StoreDto.fromMap(Map<String, dynamic> map) {
    return StoreDto(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      address: map['address'] as String?,
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
      if (address != null) 'address': address,
    };
  }

  /// Cria uma cópia do DTO com campos opcionais modificados
  StoreDto copyWith({
    String? id,
    String? name,
    String? address,
  }) {
    return StoreDto(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ address.hashCode;

  @override
  String toString() => 'StoreDto(id: $id, name: $name, address: $address)';
}
