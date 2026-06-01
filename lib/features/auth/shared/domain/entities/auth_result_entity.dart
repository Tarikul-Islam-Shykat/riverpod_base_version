class AuthResultEntity {
  const AuthResultEntity({
    required this.success,
    required this.message,
    this.token,
    this.role,
    this.email,
  });

  final bool success;
  final String message;
  final String? token;
  final String? role;
  final String? email;
}
