import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/splash_local_data_source.dart';
import '../../data/datasources/remote/splash_remote_data_source.dart';
import '../../data/repositories/splash_repository_impl.dart';
import '../../domain/entities/splash_session_entity.dart';
import '../../domain/repositories/splash_repository.dart';
import '../../domain/usecases/check_session_use_case.dart';

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  final localDataSource = ref.read(splashLocalDataSourceProvider);
  final remoteDataSource = ref.read(splashRemoteDataSourceProvider);

  return SplashRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

final checkSessionUseCaseProvider = Provider<CheckSessionUseCase>((ref) {
  final repository = ref.read(splashRepositoryProvider);
  return CheckSessionUseCase(repository);
});

final splashProvider =
    FutureProvider.autoDispose<SplashSessionEntity>((ref) async {
  final useCase = ref.read(checkSessionUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => const SplashSessionEntity(isAuthenticated: false),
    (session) => session,
  );
});
