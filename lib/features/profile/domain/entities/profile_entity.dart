class ProfileEntity {
  const ProfileEntity({
    this.id,
    this.fullName,
    this.email,
    this.image,
    this.gems,
    this.activePlan,
    this.isBlocked,
  });

  final String? id;
  final String? fullName;
  final String? email;
  final String? image;
  final int? gems;
  final bool? activePlan;
  final bool? isBlocked;
}
