import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/local/login_local_data_source.dart';
import '../../data/datasources/remote/login_remote_data_source.dart';
import '../../data/repositories/login_repository_impl.dart';
import '../../domain/repositories/login_repository.dart';
import '../../domain/usecases/login_use_case.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final remoteDataSource = ref.read(loginRemoteDataSourceProvider);
  final localDataSource = ref.read(loginLocalDataSourceProvider);

  return LoginRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(loginRepositoryProvider);
  return LoginUseCase(repository);
});
