import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(int postId);
}
