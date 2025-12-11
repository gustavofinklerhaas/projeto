import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/src/core/domain/entities/shopping_entities.dart';

void main() {
  group('ShoppingList Entity', () {
    test('ShoppingList criação com ID gerado automaticamente', () {
      final list = ShoppingList(
        name: 'Compras Semanais',
        description: 'Compras do mercado',
      );

      expect(list.name, 'Compras Semanais');
      expect(list.description, 'Compras do mercado');
      expect(list.id, isNotEmpty);
      expect(list.items, isEmpty);
      expect(list.isCompleted, false);
      expect(list.createdAt, isNotNull);
      expect(list.updatedAt, isNotNull);
    });

    test('ShoppingList.fromJson converte JSON corretamente', () {
      final json = {
        'id': 'test-1',
        'name': 'Compras',
        'description': 'Lista de compras',
        'items': [],
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'isCompleted': false,
      };

      final list = ShoppingList.fromJson(json);

      expect(list.id, 'test-1');
      expect(list.name, 'Compras');
      expect(list.description, 'Lista de compras');
      expect(list.isCompleted, false);
    });

    test('ShoppingList.toJson serializa corretamente', () {
      final list = ShoppingList(
        id: 'test-1',
        name: 'Compras',
        description: 'Lista de compras',
      );

      final json = list.toJson();

      expect(json['id'], 'test-1');
      expect(json['name'], 'Compras');
      expect(json['description'], 'Lista de compras');
      expect(json['items'], isA<List>());
      expect(json['isCompleted'], false);
    });

    test('ShoppingList.copyWith modifica campos mantendo os outros', () {
      final original = ShoppingList(
        id: 'test-1',
        name: 'Original',
        description: 'Descrição original',
      );

      final modified = original.copyWith(
        description: 'Modificada',
        isCompleted: true,
      );

      expect(modified.id, original.id);
      expect(modified.name, original.name);
      expect(modified.description, 'Modificada');
      expect(modified.isCompleted, true);
      expect(modified.createdAt, original.createdAt);
      // Original não foi alterada
      expect(original.description, 'Descrição original');
      expect(original.isCompleted, false);
    });
  });

  group('ShoppingItem Entity', () {
    test('ShoppingItem criação com valores padrão', () {
      final item = ShoppingItem(
        name: 'Leite',
      );

      expect(item.name, 'Leite');
      expect(item.quantity, 1.0);
      expect(item.unit, '');
      expect(item.isPurchased, false);
      expect(item.categoryId, isNull);
      expect(item.id, isNotEmpty);
      expect(item.createdAt, isNotNull);
    });

    test('ShoppingItem.fromJson converte JSON corretamente', () {
      final json = {
        'id': 'item-1',
        'name': 'Pão',
        'quantity': 2.0,
        'unit': 'kg',
        'categoryId': 'cat-1',
        'isPurchased': false,
        'createdAt': DateTime.now().toIso8601String(),
        'purchasedAt': null,
      };

      final item = ShoppingItem.fromJson(json);

      expect(item.id, 'item-1');
      expect(item.name, 'Pão');
      expect(item.quantity, 2.0);
      expect(item.unit, 'kg');
      expect(item.categoryId, 'cat-1');
      expect(item.isPurchased, false);
    });

    test('ShoppingItem.toJson serializa corretamente', () {
      final item = ShoppingItem(
        id: 'item-1',
        name: 'Arroz',
        quantity: 5.0,
        unit: 'kg',
        categoryId: 'cat-1',
      );

      final json = item.toJson();

      expect(json['id'], 'item-1');
      expect(json['name'], 'Arroz');
      expect(json['quantity'], 5.0);
      expect(json['unit'], 'kg');
      expect(json['categoryId'], 'cat-1');
      expect(json['isPurchased'], false);
    });

    test('ShoppingItem.copyWith marca item como comprado', () {
      final original = ShoppingItem(
        id: 'item-1',
        name: 'Leite',
        isPurchased: false,
      );

      final purchased = original.copyWith(isPurchased: true);

      expect(purchased.id, original.id);
      expect(purchased.name, original.name);
      expect(purchased.isPurchased, true);
      expect(original.isPurchased, false); // Original não foi alterada
    });
  });

  group('Category Entity', () {
    test('Category criação com cor padrão azul', () {
      final category = Category(
        name: 'Alimentos',
      );

      expect(category.name, 'Alimentos');
      expect(category.colorHex, '#2196F3');
      expect(category.id, isNotEmpty);
    });

    test('Category.fromJson converte JSON corretamente', () {
      final json = {
        'id': 'cat-1',
        'name': 'Bebidas',
        'colorHex': '#FF5722',
      };

      final category = Category.fromJson(json);

      expect(category.id, 'cat-1');
      expect(category.name, 'Bebidas');
      expect(category.colorHex, '#FF5722');
    });

    test('Category.toJson serializa corretamente', () {
      final category = Category(
        id: 'cat-1',
        name: 'Limpeza',
        colorHex: '#4CAF50',
      );

      final json = category.toJson();

      expect(json['id'], 'cat-1');
      expect(json['name'], 'Limpeza');
      expect(json['colorHex'], '#4CAF50');
    });

    test('Category.copyWith modifica cor', () {
      final original = Category(
        id: 'cat-1',
        name: 'Alimentos',
        colorHex: '#2196F3',
      );

      final modified = original.copyWith(colorHex: '#FF9800');

      expect(modified.id, original.id);
      expect(modified.name, original.name);
      expect(modified.colorHex, '#FF9800');
      expect(original.colorHex, '#2196F3'); // Original não foi alterada
    });
  });

  group('Entities Relationships', () {
    test('ShoppingList contém múltiplos itens', () {
      final item1 = ShoppingItem(name: 'Leite');
      final item2 = ShoppingItem(name: 'Pão');

      final list = ShoppingList(
        name: 'Compras',
        items: [item1, item2],
      );

      expect(list.items, hasLength(2));
      expect(list.items.first.name, 'Leite');
      expect(list.items.last.name, 'Pão');
    });

    test('ShoppingItem associado com categoria', () {
      final category = Category(name: 'Alimentos');

      final item = ShoppingItem(
        name: 'Arroz',
        categoryId: category.id,
      );

      expect(item.categoryId, category.id);
    });

    test('Serialização em cascata de ShoppingList com itens', () {
      final category = Category(name: 'Alimentos', colorHex: '#4CAF50');
      final item = ShoppingItem(
        name: 'Feijão',
        categoryId: category.id,
        quantity: 2.0,
        unit: 'kg',
      );

      final list = ShoppingList(
        name: 'Compras',
        items: [item],
      );

      final json = list.toJson();

      expect(json['items'], isA<List>());
      expect((json['items'] as List).first, isA<Map>());
      expect((json['items'] as List).first['name'], 'Feijão');
      expect((json['items'] as List).first['categoryId'], category.id);
    });
  });
}
