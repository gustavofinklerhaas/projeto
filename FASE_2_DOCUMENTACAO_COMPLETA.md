# ✅ FASE 2 - PARTE 1: ENTITY ≠ DTO + MAPPER

## Objetivo
Implementar **4 novas entidades de domínio** com padrão Entity ≠ DTO + Mapper, demonstrando separação de responsabilidades em arquitetura limpa.

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### 1️⃣ USER (Usuário do App)
- ✅ **Entity** (`lib/src/core/domain/entities/user.dart`)
  - Campos: id, email, name, avatarUrl, createdAt, updatedAt, isActive, role
  - Enum: `UserRole` (admin, user, guest)
  - Métodos: `toJson()`, `fromJson()`, `copyWith()`
  - Lógica de domínio: Type-safe role, auto-generated UUID

- ✅ **DTO** (`lib/src/core/data/dtos/user_dto.dart`)
  - Espelha exatamente schema backend
  - Datas como strings ISO8601
  - Role como string (sem enum)
  - Métodos: `fromJson()`, `toJson()`

- ✅ **Mapper** (`lib/src/core/data/mappers/user_mapper.dart`)
  - `toEntity(UserDto)` → User
  - `toDto(User)` → UserDto
  - Parse seguro de enums

- ✅ **Testes** (3 testes)
  - ✓ DTO → Entity conversion
  - ✓ Entity → DTO conversion
  - ✓ Round-trip data integrity

---

### 2️⃣ SHOPPING LIST SHARE (Compartilhamento de Listas)
- ✅ **Entity** (`lib/src/core/domain/entities/shopping_list_share.dart`)
  - Campos: id, shoppingListId, ownerId, sharedWithUserId, permission, sharedAt, acceptedAt, isActive
  - Enum: `SharePermission` (view, edit, admin)
  - Métodos: `toJson()`, `fromJson()`, `copyWith()`, `isAccepted` (computed property)
  - Lógica de domínio: Permission-based access control

- ✅ **DTO** (`lib/src/core/data/dtos/shopping_list_share_dto.dart`)
  - Datas como strings ISO8601
  - Permission como string
  - Métodos: `fromJson()`, `toJson()`

- ✅ **Mapper** (`lib/src/core/data/mappers/shopping_list_share_mapper.dart`)
  - `toEntity(ShoppingListShareDto)` → ShoppingListShare
  - `toDto(ShoppingListShare)` → ShoppingListShareDto
  - Parse seguro de permission enums

- ✅ **Testes** (3 testes)
  - ✓ DTO → Entity conversion
  - ✓ Entity → DTO conversion
  - ✓ Round-trip data integrity

---

### 3️⃣ SHOPPING ITEM HISTORY (Histórico de Compras)
- ✅ **Entity** (`lib/src/core/domain/entities/shopping_item_history.dart`)
  - Campos: id, itemId, listId, itemName, quantity, unit, purchasedAt, costPerUnit, storeId
  - Métodos: `toJson()`, `fromJson()`, `copyWith()`
  - Lógica de domínio: `totalCost` (quantity × costPerUnit)
  - Suporte a custo opcional (nullable costPerUnit)

- ✅ **DTO** (`lib/src/core/data/dtos/shopping_item_history_dto.dart`)
  - Data como string ISO8601
  - Valores numéricos com type safety
  - Métodos: `fromJson()`, `toJson()`

- ✅ **Mapper** (`lib/src/core/data/mappers/shopping_item_history_mapper.dart`)
  - `toEntity(ShoppingItemHistoryDto)` → ShoppingItemHistory
  - `toDto(ShoppingItemHistory)` → ShoppingItemHistoryDto
  - Conversão bidirecional de datas

- ✅ **Testes** (3 testes)
  - ✓ DTO → Entity conversion
  - ✓ Entity → DTO conversion
  - ✓ Round-trip data integrity

---

### 4️⃣ STORE (Lojas/Supermercados)
- ✅ **Entity** (`lib/src/core/domain/entities/store.dart`)
  - Campos: id, name, address, latitude, longitude, phone, website, acceptedPaymentMethods, averageRating, reviewCount, isFavorite, createdAt
  - Métodos: `toJson()`, `fromJson()`, `copyWith()`
  - Lógica de domínio: `getDistanceKm(userLat, userLng)` com Haversine
  - Suporte a geolocalização

- ✅ **DTO** (`lib/src/core/data/dtos/store_dto.dart`)
  - Espelha schema backend com coordenadas e avaliação
  - Data como string ISO8601
  - Métodos: `fromJson()`, `toJson()`

- ✅ **Mapper** (`lib/src/core/data/mappers/store_mapper.dart`)
  - `toEntity(StoreDto)` → Store
  - `toDto(Store)` → StoreDto
  - Default value handling para reviewCount

- ✅ **Testes** (4 testes)
  - ✓ DTO → Entity conversion
  - ✓ Entity → DTO conversion
  - ✓ Round-trip data integrity
  - ✓ Haversine distance calculation

---

## 🧪 RESULTADOS DOS TESTES

**Arquivo**: `test/entity_dto_mapper_test.dart`

### Status: ✅ 13 TESTES PASSANDO (100%)

```
UserMapper:
  ✓ deve converter UserDto para User Entity corretamente
  ✓ deve converter User Entity para UserDto corretamente
  ✓ deve fazer round-trip sem perder dados

ShoppingListShareMapper:
  ✓ deve converter ShoppingListShareDto para ShoppingListShare Entity
  ✓ deve converter ShoppingListShare Entity para ShoppingListShareDto
  ✓ deve fazer round-trip sem perder dados

ShoppingItemHistoryMapper:
  ✓ deve converter ShoppingItemHistoryDto para ShoppingItemHistory Entity
  ✓ deve converter ShoppingItemHistory Entity para ShoppingItemHistoryDto
  ✓ deve fazer round-trip sem perder dados

StoreMapper:
  ✓ deve converter StoreDto para Store Entity corretamente
  ✓ deve converter Store Entity para StoreDto corretamente
  ✓ deve fazer round-trip sem perder dados
  ✓ deve calcular distância corretamente (Haversine)
```

---

## 📊 ESTATÍSTICAS

| Métrica | Valor |
|---------|-------|
| **Entidades criadas** | 4 |
| **DTOs criados** | 4 |
| **Mappers criados** | 4 |
| **Testes implementados** | 13 |
| **Taxa de sucesso de testes** | 100% ✅ |
| **Linhas de código** | ~2,000+ |
| **Commits** | 2 |
| **Arquivos criados** | 13 |

---

## 🏗️ ARQUITETURA: ENTITY ≠ DTO + MAPPER

### Fluxo de Dados

```
Backend API
    ↓ (JSON)
   [DTO]  ← String dates, string enums, NO logic
    ↓ (Mapper.toEntity)
 [Entity] ← DateTime fields, type-safe enums, domain logic
    ↓
Business Logic Layer
```

### Separação de Responsabilidades

**Entity** (Domain Layer)
- Type-safe types (DateTime, enums)
- Domain logic (computed properties, validations)
- Business invariants (permissions, costs calculations)
- Zero backend concerns

**DTO** (Data Layer)
- Exact mirror of backend API schema
- String dates (ISO8601), string enums
- Zero business logic, pure data representation
- Serialization/deserialization only

**Mapper** (Conversion Layer)
- DTO → Entity (Type conversions, enum parsing)
- Entity → DTO (Serialization, default values)
- No business logic, only normalization
- Testable, reusable conversion functions

---

## 🔗 ESTRUTURA DE ARQUIVOS

```
lib/src/core/
├── domain/
│   └── entities/
│       ├── user.dart ✅
│       ├── shopping_list_share.dart ✅
│       ├── shopping_item_history.dart ✅
│       └── store.dart ✅
│
└── data/
    ├── dtos/
    │   ├── user_dto.dart ✅
    │   ├── shopping_list_share_dto.dart ✅
    │   ├── shopping_item_history_dto.dart ✅
    │   └── store_dto.dart ✅
    │
    └── mappers/
        ├── user_mapper.dart ✅
        ├── shopping_list_share_mapper.dart ✅
        ├── shopping_item_history_mapper.dart ✅
        └── store_mapper.dart ✅

test/
└── entity_dto_mapper_test.dart ✅
```

---

## 📝 EXEMPLOS DE CÓDIGO

### 1. Entity com Type Safety e Domínio Logic

```dart
// User Entity - Type-safe, domain logic
class User {
  final String id;
  final String email;
  final UserRole role;  // ← Enum (type-safe)
  final DateTime createdAt;  // ← DateTime (domain type)
  
  User copyWith({...}) => User(...);
}

enum UserRole { admin, user, guest }
```

### 2. DTO Espelhando Backend

```dart
// UserDto - Exact backend schema
class UserDto {
  final String id;
  final String email;
  final String role;  // ← String (backend format)
  final String createdAt;  // ← String (backend format)
  
  factory UserDto.fromJson(json) => UserDto(...);
  Map<String, dynamic> toJson() => {...};
}
```

### 3. Mapper Bidirecional

```dart
// UserMapper - Conversão limpa
class UserMapper {
  static User toEntity(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      role: _parseRole(dto.role),  // String → Enum
      createdAt: DateTime.parse(dto.createdAt),  // String → DateTime
    );
  }

  static UserDto toDto(User entity) {
    return UserDto(
      id: entity.id,
      email: entity.email,
      role: entity.role.name,  // Enum → String
      createdAt: entity.createdAt.toIso8601String(),  // DateTime → String
    );
  }
}
```

### 4. Uso na Aplicação

```dart
// 1. Backend retorna JSON
final backendJson = {
  'id': '123',
  'email': 'user@example.com',
  'role': 'admin',  // string
  'createdAt': '2024-01-01T10:00:00.000Z'  // string
};

// 2. Desserializar para DTO
final userDto = UserDto.fromJson(backendJson);

// 3. Converter para Entity (com type safety)
final userEntity = UserMapper.toEntity(userDto);

// 4. Usar Entity com confiança
if (userEntity.role == UserRole.admin) {
  // Lógica admin
}

// 5. Converter de volta para DTO se necessário
final updatedDto = UserMapper.toDto(userEntity);
```

---

## ✨ BENEFÍCIOS DESSA ARQUITETURA

✅ **Type Safety**
- Enums em entidades previnem erros de runtime
- DateTime garante operações de data confiáveis

✅ **Separação de Responsabilidades**
- Entity = Domínio puro (sem API concerns)
- DTO = Data transfer (sem lógica)
- Mapper = Conversão (sem regras)

✅ **Testabilidade**
- Cada layer testável independentemente
- 13 testes validando conversões

✅ **Manutenibilidade**
- Mappers centralizados
- Mudanças no backend isoladas em DTOs
- Entidades não afetadas por mudanças de API

✅ **Escalabilidade**
- Padrão aplicável a N entidades
- Fácil adicionar novos mappers
- Documentação clara

✅ **Aderência a SOLID**
- Single Responsibility Principle
- Open/Closed Principle
- Dependency Inversion

---

## 🔄 COMMITS GIT

```bash
# Commit 1: DTOs, Mappers e Testes
commit 3de8244
feat: add DTOs, mappers and tests for entity-DTO conversions
- 9 files changed, 735 insertions(+)
- Add ShoppingListShareDto, ShoppingItemHistoryDto, StoreDto
- Add UserMapper, ShareMapper, HistoryMapper, StoreMapper
- Add comprehensive test suite with round-trip validation

# Commit 2: Correções e Validação
commit efbfb7e
test: fix imports and entity-dto mapper tests - all 13 tests passing
- 8 files changed, 443 insertions(+)
- Fix package name in test imports
- Fix StoreMapper null handling
- All 13 tests passing ✅
```

---

## 📌 PRÓXIMAS ETAPAS (Fase 2, Parte 2)

- [ ] Integrar Mappers com Repository Pattern
- [ ] Criar Use Cases que usam Entities
- [ ] Implementar Screens/ViewModels com Entities
- [ ] Persistência local com DTOs + Mappers
- [ ] Integração completa com Backend API

---

## 🎯 RESUMO TÉCNICO

| Aspecto | Implementação |
|--------|----------------|
| Padrão | Entity ≠ DTO + Mapper |
| Entidades | 4 (User, Share, History, Store) |
| DTOs | 4 (mirror de backend) |
| Mappers | 4 (bidirecional) |
| Testes | 13 (100% passing) |
| Type Safety | Enums + DateTime |
| Domain Logic | Computed properties, validations |
| Backend Mirror | Strings e tipos primitivos |
| Code Style | Dartfmt + analysis_options.yaml |

---

**Status**: ✅ **FASE 2, PARTE 1 - COMPLETA**

Desenvolvido com Clean Architecture + SOLID Principles  
Pronto para integração com camadas superiores  
100% testes passando

*Próximo*: Fase 2, Parte 2 - Repository Pattern + Use Cases
