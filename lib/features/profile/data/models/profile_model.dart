import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  const ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      image: json['image']?.toString(),
      gems: json['gems'] is int ? json['gems'] as int : null,
      activePlan: json['activePlan'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      fullName: fullName,
      email: email,
      image: image,
      gems: gems,
      activePlan: activePlan,
      isBlocked: isBlocked,
    );
  }
}
