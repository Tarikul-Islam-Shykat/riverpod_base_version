class SplashSessionEntity {
  const SplashSessionEntity({
    required this.isAuthenticated,
    this.role,
  });

  final bool isAuthenticated;
  final String? role;

  bool get isAdmin => role?.toLowerCase() == 'admin';
}

