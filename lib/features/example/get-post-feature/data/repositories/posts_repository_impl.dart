import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_data_source.dart';

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._remoteDataSource);

  final PostsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    final result = await _remoteDataSource.getPosts();

    return result.map(
      (posts) => posts
          .map(
            (post) => PostEntity(
              userId: post.userId,
              id: post.id,
              title: post.title,
              body: post.body,
            ),
          )
          .toList(growable: false),
    );
  }
}
