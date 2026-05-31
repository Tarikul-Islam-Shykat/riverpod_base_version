import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/network/service/network_service.dart';
import '../../data/datasources/posts_remote_data_source.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/usecases/get_posts_use_case.dart';

final postsRemoteDataSourceProvider = Provider<PostsRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return PostsRemoteDataSource(networkService);
});

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  final remoteDataSource = ref.read(postsRemoteDataSourceProvider);
  return PostsRepositoryImpl(remoteDataSource);
});

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  final repository = ref.read(postsRepositoryProvider);
  return GetPostsUseCase(repository);
});

final postsProvider = FutureProvider.autoDispose<List<PostEntity>>((ref) async {
  final useCase = ref.watch(getPostsUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (posts) => posts,
  );
});
