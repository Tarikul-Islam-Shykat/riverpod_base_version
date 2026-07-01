import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/social_post_local_data_source.dart';
import '../../data/repositories/social_post_repository_impl.dart';
import '../../domain/entities/social_post_entity.dart';
import '../../domain/repositories/social_post_repository.dart';
import '../../domain/usecases/get_social_posts_use_case.dart';

final socialPostLocalDataSourceProvider =
    Provider<SocialPostLocalDataSource>((ref) {
  return SocialPostLocalDataSource();
});

final socialPostRepositoryProvider = Provider<SocialPostRepository>((ref) {
  final localDataSource = ref.read(socialPostLocalDataSourceProvider);
  return SocialPostRepositoryImpl(localDataSource);
});

final getSocialPostsUseCaseProvider = Provider<GetSocialPostsUseCase>((ref) {
  final repository = ref.read(socialPostRepositoryProvider);
  return GetSocialPostsUseCase(repository);
});

final socialPostsProvider =
    FutureProvider.autoDispose<List<SocialPostEntity>>((ref) async {
  final useCase = ref.read(getSocialPostsUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (posts) => posts,
  );
});
