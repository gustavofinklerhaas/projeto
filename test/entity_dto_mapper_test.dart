import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/src/core/data/dtos/user_dto.dart';
import 'package:flutter_application_1/src/core/data/dtos/shopping_list_share_dto.dart';
import 'package:flutter_application_1/src/core/data/dtos/shopping_item_history_dto.dart';
import 'package:flutter_application_1/src/core/data/dtos/store_dto.dart';
import 'package:flutter_application_1/src/core/data/mappers/user_mapper.dart';
import 'package:flutter_application_1/src/core/data/mappers/shopping_list_share_mapper.dart';
import 'package:flutter_application_1/src/core/data/mappers/shopping_item_history_mapper.dart';
import 'package:flutter_application_1/src/core/data/mappers/store_mapper.dart';
import 'package:flutter_application_1/src/core/domain/entities/user.dart';
import 'package:flutter_application_1/src/core/domain/entities/shopping_list_share.dart';
import 'package:flutter_application_1/src/core/domain/entities/shopping_item_history.dart';
import 'package:flutter_application_1/src/core/domain/entities/store.dart';

void main() {
  group('Entity ↔ DTO Mappers Test Suite', () {
    // ============ USER TESTS ============
    group('UserMapper', () {
      test('deve converter UserDto para User Entity corretamente', () {
        // Arrange
        final userDto = UserDto(
          id: '123',
          email: 'teste@example.com',
          name: 'João Silva',
          avatarUrl: 'https://example.com/avatar.jpg',
          createdAt: '2024-01-01T10:00:00.000Z',
          updatedAt: '2024-01-02T10:00:00.000Z',
          isActive: true,
          role: 'admin',
        );

        // Act
        final userEntity = UserMapper.toEntity(userDto);

        // Assert
        expect(userEntity.id, equals('123'));
        expect(userEntity.email, equals('teste@example.com'));
        expect(userEntity.name, equals('João Silva'));
        expect(userEntity.isActive, equals(true));
        expect(userEntity.role, equals(UserRole.admin));
        expect(userEntity.createdAt, isA<DateTime>());
      });

      test('deve converter User Entity para UserDto corretamente', () {
        // Arrange
        final userEntity = User(
          id: '456',
          email: 'maria@example.com',
          name: 'Maria Santos',
          avatarUrl: 'https://example.com/avatar2.jpg',
          createdAt: DateTime(2024, 1, 1, 10),
          updatedAt: DateTime(2024, 1, 2, 10),
          isActive: true,
          role: UserRole.user,
        );

        // Act
        final userDto = UserMapper.toDto(userEntity);

        // Assert
        expect(userDto.id, equals('456'));
        expect(userDto.email, equals('maria@example.com'));
        expect(userDto.name, equals('Maria Santos'));
        expect(userDto.isActive, equals(true));
        expect(userDto.role, equals('user'));
      });

      test('deve fazer round-trip sem perder dados', () {
        // Arrange
        final dtoOriginal = UserDto(
          id: '789',
          email: 'teste@example.com',
          name: 'Pedro Costa',
          avatarUrl: 'https://example.com/avatar3.jpg',
          createdAt: '2024-01-01T10:00:00.000Z',
          updatedAt: '2024-01-02T10:00:00.000Z',
          isActive: true,
          role: 'guest',
        );

        // Act
        final entity = UserMapper.toEntity(dtoOriginal);
        final dtoFinal = UserMapper.toDto(entity);

        // Assert
        expect(dtoFinal.id, equals(dtoOriginal.id));
        expect(dtoFinal.email, equals(dtoOriginal.email));
        expect(dtoFinal.role, equals(dtoOriginal.role));
      });
    });

    // ============ SHOPPING LIST SHARE TESTS ============
    group('ShoppingListShareMapper', () {
      test('deve converter ShoppingListShareDto para ShoppingListShare Entity', () {
        // Arrange
        final shareDto = ShoppingListShareDto(
          id: 'share-001',
          shoppingListId: 'list-001',
          ownerId: 'user-001',
          sharedWithUserId: 'user-002',
          permission: 'edit',
          sharedAt: '2024-01-01T10:00:00.000Z',
          acceptedAt: '2024-01-01T12:00:00.000Z',
          isActive: true,
        );

        // Act
        final shareEntity = ShoppingListShareMapper.toEntity(shareDto);

        // Assert
        expect(shareEntity.id, equals('share-001'));
        expect(shareEntity.shoppingListId, equals('list-001'));
        expect(shareEntity.permission, equals(SharePermission.edit));
        expect(shareEntity.isAccepted, equals(true));
      });

      test('deve converter ShoppingListShare Entity para ShoppingListShareDto', () {
        // Arrange
        final shareEntity = ShoppingListShare(
          id: 'share-002',
          shoppingListId: 'list-002',
          ownerId: 'user-001',
          sharedWithUserId: 'user-003',
          permission: SharePermission.view,
          sharedAt: DateTime(2024, 1, 1, 10),
          acceptedAt: null,
          isActive: true,
        );

        // Act
        final shareDto = ShoppingListShareMapper.toDto(shareEntity);

        // Assert
        expect(shareDto.id, equals('share-002'));
        expect(shareDto.permission, equals('view'));
        expect(shareDto.acceptedAt, isNull);
        expect(shareDto.isActive, equals(true));
      });

      test('deve fazer round-trip sem perder dados', () {
        // Arrange
        final dtoOriginal = ShoppingListShareDto(
          id: 'share-003',
          shoppingListId: 'list-003',
          ownerId: 'user-001',
          sharedWithUserId: 'user-004',
          permission: 'admin',
          sharedAt: '2024-01-01T10:00:00.000Z',
          acceptedAt: null,
          isActive: true,
        );

        // Act
        final entity = ShoppingListShareMapper.toEntity(dtoOriginal);
        final dtoFinal = ShoppingListShareMapper.toDto(entity);

        // Assert
        expect(dtoFinal.id, equals(dtoOriginal.id));
        expect(dtoFinal.permission, equals(dtoOriginal.permission));
        expect(dtoFinal.shoppingListId, equals(dtoOriginal.shoppingListId));
      });
    });

    // ============ SHOPPING ITEM HISTORY TESTS ============
    group('ShoppingItemHistoryMapper', () {
      test('deve converter ShoppingItemHistoryDto para ShoppingItemHistory Entity', () {
        // Arrange
        final historyDto = ShoppingItemHistoryDto(
          id: 'hist-001',
          itemId: 'item-001',
          listId: 'list-001',
          itemName: 'Leite',
          quantity: 2.0,
          unit: 'L',
          purchasedAt: '2024-01-01T14:30:00.000Z',
          costPerUnit: 5.50,
          storeId: 'store-001',
        );

        // Act
        final historyEntity = ShoppingItemHistoryMapper.toEntity(historyDto);

        // Assert
        expect(historyEntity.id, equals('hist-001'));
        expect(historyEntity.itemName, equals('Leite'));
        expect(historyEntity.quantity, equals(2.0));
        expect(historyEntity.costPerUnit, equals(5.50));
        expect(historyEntity.totalCost, equals(11.0)); // 2.0 * 5.50
      });

      test('deve converter ShoppingItemHistory Entity para ShoppingItemHistoryDto', () {
        // Arrange
        final historyEntity = ShoppingItemHistory(
          id: 'hist-002',
          itemId: 'item-002',
          listId: 'list-002',
          itemName: 'Pão',
          quantity: 1.0,
          unit: 'unidade',
          purchasedAt: DateTime(2024, 1, 1, 15),
          costPerUnit: 3.50,
          storeId: 'store-002',
        );

        // Act
        final historyDto = ShoppingItemHistoryMapper.toDto(historyEntity);

        // Assert
        expect(historyDto.id, equals('hist-002'));
        expect(historyDto.itemName, equals('Pão'));
        expect(historyDto.costPerUnit, equals(3.50));
        expect(historyDto.storeId, equals('store-002'));
      });

      test('deve fazer round-trip sem perder dados', () {
        // Arrange
        final dtoOriginal = ShoppingItemHistoryDto(
          id: 'hist-003',
          itemId: 'item-003',
          listId: 'list-003',
          itemName: 'Arroz',
          quantity: 5.0,
          unit: 'kg',
          purchasedAt: '2024-01-01T16:00:00.000Z',
          costPerUnit: 8.99,
          storeId: 'store-003',
        );

        // Act
        final entity = ShoppingItemHistoryMapper.toEntity(dtoOriginal);
        final dtoFinal = ShoppingItemHistoryMapper.toDto(entity);

        // Assert
        expect(dtoFinal.id, equals(dtoOriginal.id));
        expect(dtoFinal.itemName, equals(dtoOriginal.itemName));
        expect(dtoFinal.quantity, equals(dtoOriginal.quantity));
      });
    });

    // ============ STORE TESTS ============
    group('StoreMapper', () {
      test('deve converter StoreDto para Store Entity corretamente', () {
        // Arrange
        final storeDto = StoreDto(
          id: 'store-001',
          name: 'Supermercado Central',
          address: 'Rua das Flores, 123',
          latitude: -23.5505,
          longitude: -46.6333,
          phone: '11-3333-3333',
          website: 'www.supermercadocentral.com.br',
          acceptedPaymentMethods: ['cartao', 'dinheiro', 'pix'],
          averageRating: 4.5,
          reviewCount: 120,
          isFavorite: true,
          createdAt: '2024-01-01T10:00:00.000Z',
        );

        // Act
        final storeEntity = StoreMapper.toEntity(storeDto);

        // Assert
        expect(storeEntity.id, equals('store-001'));
        expect(storeEntity.name, equals('Supermercado Central'));
        expect(storeEntity.latitude, equals(-23.5505));
        expect(storeEntity.longitude, equals(-46.6333));
        expect(storeEntity.isFavorite, equals(true));
        expect(storeEntity.acceptedPaymentMethods.length, equals(3));
      });

      test('deve converter Store Entity para StoreDto corretamente', () {
        // Arrange
        final storeEntity = Store(
          id: 'store-002',
          name: 'Mercadinho da Esquina',
          address: 'Avenida Principal, 456',
          latitude: -23.5600,
          longitude: -46.6400,
          phone: null,
          website: null,
          acceptedPaymentMethods: ['dinheiro'],
          averageRating: null,
          reviewCount: null,
          isFavorite: false,
          createdAt: DateTime(2024, 1, 1, 10),
        );

        // Act
        final storeDto = StoreMapper.toDto(storeEntity);

        // Assert
        expect(storeDto.id, equals('store-002'));
        expect(storeDto.name, equals('Mercadinho da Esquina'));
        expect(storeDto.phone, isNull);
        expect(storeDto.isFavorite, equals(false));
      });

      test('deve fazer round-trip sem perder dados', () {
        // Arrange
        final dtoOriginal = StoreDto(
          id: 'store-003',
          name: 'Loja do Bairro',
          address: 'Rua Secundária, 789',
          latitude: -23.5555,
          longitude: -46.6355,
          phone: '11-2222-2222',
          website: 'www.lojabairro.com.br',
          acceptedPaymentMethods: ['cartao', 'pix'],
          averageRating: 3.8,
          reviewCount: 45,
          isFavorite: true,
          createdAt: '2024-01-01T10:00:00.000Z',
        );

        // Act
        final entity = StoreMapper.toEntity(dtoOriginal);
        final dtoFinal = StoreMapper.toDto(entity);

        // Assert
        expect(dtoFinal.id, equals(dtoOriginal.id));
        expect(dtoFinal.name, equals(dtoOriginal.name));
        expect(dtoFinal.latitude, equals(dtoOriginal.latitude));
        expect(dtoFinal.acceptedPaymentMethods.length, equals(dtoOriginal.acceptedPaymentMethods.length));
      });

      test('deve calcular distância corretamente (Haversine)', () {
        // Arrange - São Paulo (app) e Rio de Janeiro (store)
        final storeEntity = Store(
          id: 'store-004',
          name: 'Supermercado Rio',
          address: 'Rio de Janeiro, RJ',
          latitude: -22.9068,
          longitude: -43.1729,
          phone: null,
          website: null,
          acceptedPaymentMethods: ['cartao'],
          averageRating: null,
          reviewCount: null,
          isFavorite: false,
          createdAt: DateTime.now(),
        );

        // Act - Distância aproximada São Paulo (user) para Rio (store)
        final distancia = storeEntity.getDistanceKm(-23.5505, -46.6333);

        // Assert - Distância SP-RJ é aproximadamente 430 km
        expect(distancia, greaterThan(400));
        expect(distancia, lessThan(450));
      });
    });
  });
}
