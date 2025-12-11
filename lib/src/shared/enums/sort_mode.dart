/// Enum para modos de ordenação da lista de compras
/// 
/// Defines sorting strategies available for shopping items:
/// - nameAZ: Sort by title A→Z
/// - nameZA: Sort by title Z→A
/// - category: Sort by category ID
/// - doneAtEnd: Keep incomplete items first, done at end
/// - createdDate: Sort by creation date (newest first)
enum SortMode {
  nameAZ,
  nameZA,
  category,
  doneAtEnd,
  createdDate,
}

/// Extension para adicionar propriedades úteis ao SortMode
extension SortModeExtension on SortMode {
  /// Retorna o rótulo exibível em UI
  String get label {
    switch (this) {
      case SortMode.nameAZ:
        return 'Alfabético (A→Z)';
      case SortMode.nameZA:
        return 'Alfabético (Z→A)';
      case SortMode.category:
        return 'Por Categoria';
      case SortMode.doneAtEnd:
        return 'Itens Pendentes Primeiro';
      case SortMode.createdDate:
        return 'Por Data de Criação';
    }
  }

  /// Retorna o valor para serialização
  String get value {
    return toString().split('.').last;
  }

  /// Factory para desserializar a partir de string
  static SortMode fromValue(String value) {
    return SortMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => SortMode.nameAZ,
    );
  }
}
