import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/social_post_entity.dart';

abstract class SocialPostRepository {
  Future<Either<Failure, List<SocialPostEntity>>> getPosts();
}
