import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../domain/entities/social_post_entity.dart';
import '../../domain/repositories/social_post_repository.dart';
import '../datasources/local/social_post_local_data_source.dart';
import '../models/social_post_model.dart';

class SocialPostRepositoryImpl implements SocialPostRepository {
  SocialPostRepositoryImpl(this._localDataSource);

  final SocialPostLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<SocialPostEntity>>> getPosts() async {
    try {
      final posts = await _localDataSource.getPosts();
      return Right(posts.map(_toEntity).toList(growable: false));
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }

  SocialPostEntity _toEntity(SocialPostModel model) => model.toEntity();
}
