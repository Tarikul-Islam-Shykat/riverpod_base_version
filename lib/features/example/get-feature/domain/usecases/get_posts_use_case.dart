import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  GetPostsUseCase(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, List<PostEntity>>> call() {
    return _repository.getPosts();
  }
}
