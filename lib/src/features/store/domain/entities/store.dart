/// Store Entity
/// 
/// Entidade que representa um estabelecimento/loja de compras.
/// Segue os princípios de Clean Architecture:
/// - Imutável (final fields)
/// - Independente de camadas inferiores
/// - Sem dependências de DTO ou Model
/// - Contém apenas a lógica de negócios essencial
class Store {
  final String id;
  final String name;
  final String? address;

  /// Construtor da entidade Store
  /// 
  /// Parâmetros:
  ///   - id: Identificador único da loja
  ///   - name: Nome da loja (ex: "Supermercado ABC")
  ///   - address: Endereço da loja (opcional)
  const Store({
    required this.id,
    required this.name,
    this.address,
  });

  /// Cria uma cópia da loja com campos opcionais modificados
  /// 
  /// Útil para atualizar apenas alguns campos sem criar uma nova instância
  /// do zero. Segue o padrão de imutabilidade funcional.
  Store copyWith({
    String? id,
    String? name,
    String? address,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ address.hashCode;

  @override
  String toString() => 'Store(id: $id, name: $name, address: $address)';
}
