import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetCommentsUseCase {
  GetCommentsUseCase(this._repository);

  final CommentRepository _repository;

  Future<Either<Failure, List<CommentEntity>>> call(int postId) {
    return _repository.getCommentsByPostId(postId);
  }
}
