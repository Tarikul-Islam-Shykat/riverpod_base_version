class LocalUserEntity {
  const LocalUserEntity({
    required this.id,
    required this.email,
    this.fullName,
  });

  final String id;
  final String email;
  final String? fullName;
}
