import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/social_post_entity.dart';
import '../repositories/social_post_repository.dart';

class GetSocialPostsUseCase {
  GetSocialPostsUseCase(this._repository);

  final SocialPostRepository _repository;

  Future<Either<Failure, List<SocialPostEntity>>> call() {
    return _repository.getPosts();
  }
}
