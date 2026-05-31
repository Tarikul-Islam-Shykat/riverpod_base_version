import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/local_storage_service/shared/app_db.dart';
import '../../../../../core/services/network/service/network_service.dart';
import '../../data/datasources/local/user_local_data_source.dart';
import '../../data/datasources/remote/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/local_user_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_use_case.dart';
import '../../domain/usecases/local_user_use_case.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return UserRemoteDataSource(networkService);
});

final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  final database = ref.read(appDbProvider);
  return UserLocalDataSource(database);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  final localDataSource = ref.read(userLocalDataSourceProvider);

  return UserRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUsersUseCase(repository);
});

final localUserUseCaseProvider = Provider<LocalUserUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return LocalUserUseCase(repository);
});

final usersProvider = FutureProvider.autoDispose<List<UserEntity>>((ref) async {
  final useCase = ref.read(getUsersUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
});

final savedUserProvider =
    FutureProvider.autoDispose<LocalUserEntity?>((ref) async {
  final useCase = ref.read(localUserUseCaseProvider);
  final result = await useCase.getSavedUser();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
});
