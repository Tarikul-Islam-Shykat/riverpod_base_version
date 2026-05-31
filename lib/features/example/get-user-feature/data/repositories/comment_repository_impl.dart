import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this._remoteDataSource);

  final CommentRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(
    int postId,
  ) async {
    final result = await _remoteDataSource.getCommentsByPostId(postId);

    return result.map(
      (comments) =>
          comments.map((comment) => comment.toEntity()).toList(growable: false),
    );
  }
}
