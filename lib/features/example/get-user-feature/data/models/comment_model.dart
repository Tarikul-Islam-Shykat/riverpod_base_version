import '../../domain/entities/comment_entity.dart';

class CommentModel {
  const CommentModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      postId: (json['postId'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      postId: postId,
      id: id,
      name: name,
      email: email,
      body: body,
    );
  }
}
