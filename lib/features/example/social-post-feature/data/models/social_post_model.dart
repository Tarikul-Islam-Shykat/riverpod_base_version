import '../../domain/entities/social_post_entity.dart';

class SocialPostModel {
  const SocialPostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String body;
  final String imageUrl;

  SocialPostEntity toEntity() {
    return SocialPostEntity(
      id: id,
      title: title,
      body: body,
      imageUrl: imageUrl,
    );
  }
}
