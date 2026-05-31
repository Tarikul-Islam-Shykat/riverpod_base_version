import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/network/service/network_service.dart';
import '../../data/datasources/comment_remote_data_source.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../../domain/usecases/get_comments_use_case.dart';

final commentRemoteDataSourceProvider =
    Provider<CommentRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return CommentRemoteDataSource(networkService);
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final remoteDataSource = ref.read(commentRemoteDataSourceProvider);
  return CommentRepositoryImpl(remoteDataSource);
});

final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  final repository = ref.read(commentRepositoryProvider);
  return GetCommentsUseCase(repository);
});

final commentsProvider =
    FutureProvider.autoDispose.family<List<CommentEntity>, int>(
  (ref, postId) async {
    final useCase = ref.read(getCommentsUseCaseProvider);
    final result = await useCase(postId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (comments) => comments,
    );
  },
);
