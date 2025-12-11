import '../dtos/user_dto.dart';
import '../../domain/entities/user.dart';

/// Mapper: User Entity ↔ User DTO
class UserMapper {
  /// Converte UserDto → User Entity
  static User toEntity(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      name: dto.name,
      avatarUrl: dto.avatarUrl,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
      isActive: dto.isActive,
      role: _parseRole(dto.role),
    );
  }

  /// Converte User Entity → UserDto
  static UserDto toDto(User entity) {
    return UserDto(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      isActive: entity.isActive,
      role: entity.role.name,
    );
  }

  /// Parse string para UserRole enum
  static UserRole _parseRole(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      case 'guest':
        return UserRole.guest;
      default:
        return UserRole.user;
    }
  }
}
