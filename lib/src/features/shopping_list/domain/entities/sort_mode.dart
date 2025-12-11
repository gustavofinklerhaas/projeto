/// SortMode
/// 
/// Define as opções de ordenação para a lista de compras
enum SortMode {
  nameAZ,        // Alfabético A→Z
  nameZA,        // Alfabético Z→A
  category,      // Por categoria
  doneAtEnd,     // Itens marcados no final
  createdDate,   // Por data de criação (mais novo primeiro)
}

extension SortModeExtension on SortMode {
  String get label {
    switch (this) {
      case SortMode.nameAZ:
        return 'A→Z';
      case SortMode.nameZA:
        return 'Z→A';
      case SortMode.category:
        return 'Categoria';
      case SortMode.doneAtEnd:
        return 'Pendentes';
      case SortMode.createdDate:
        return 'Mais Novo';
    }
  }

  String get value {
    switch (this) {
      case SortMode.nameAZ:
        return 'nameAZ';
      case SortMode.nameZA:
        return 'nameZA';
      case SortMode.category:
        return 'category';
      case SortMode.doneAtEnd:
        return 'doneAtEnd';
      case SortMode.createdDate:
        return 'createdDate';
    }
  }

  static SortMode fromValue(String value) {
    return SortMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => SortMode.nameAZ,
    );
  }
}
