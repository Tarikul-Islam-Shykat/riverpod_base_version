import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  GetPostsUseCase(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, List<PostEntity>>> call({
    int limit = 20,
  }) async {
    final result = await _repository.getPosts();

    return result.map(
      (posts) {
        final normalizedPosts = posts
            .where(
              (post) =>
                  post.title.trim().isNotEmpty && post.body.trim().isNotEmpty,
            )
            .map(
              (post) => PostEntity(
                userId: post.userId,
                id: post.id,
                title: post.title.trim(),
                body: post.body.trim(),
              ),
            )
            .toList(growable: false)
          ..sort((left, right) => right.id.compareTo(left.id));

        if (limit <= 0) {
          return const <PostEntity>[];
        }

        return normalizedPosts.take(limit).toList(growable: false);
      },
    );
  }
}
