/// DTO: User (espelhando schema remoto da API)
/// Mantém fiel ao backend, sem lógica de negócio
class UserDto {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String createdAt;
  final String updatedAt;
  final bool isActive;
  final String role;

  UserDto({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.role,
  });

  /// Serializa para JSON (envio ao backend)
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatarUrl': avatarUrl,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'isActive': isActive,
        'role': role,
      };

  /// Desserializa de JSON (recebimento do backend)
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isActive: json['isActive'] as bool,
      role: json['role'] as String,
    );
  }
}
