import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/network/service/network_service.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_use_case.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return UserRemoteDataSource(networkService);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource);
});

final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUsersUseCase(repository);
});

final usersProvider = FutureProvider.autoDispose<List<UserEntity>>((ref) async {
  final useCase = ref.read(getUsersUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
});
