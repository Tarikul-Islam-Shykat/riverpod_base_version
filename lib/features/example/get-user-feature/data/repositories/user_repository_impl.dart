import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../domain/entities/local_user_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_data_source.dart';
import '../datasources/remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    final result = await _remoteDataSource.getUsers();

    return result.map(
      (users) => users.map((user) => user.toEntity()).toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, void>> saveUser(LocalUserEntity user) async {
    try {
      await _localDataSource.saveUser(user);
      return const Right(null);
    } catch (_) {
      return Left(UnknownFailure('Failed to save user locally'));
    }
  }

  @override
  Future<Either<Failure, LocalUserEntity?>> getSavedUser() async {
    try {
      final user = await _localDataSource.getSavedUser();
      return Right(user);
    } catch (_) {
      return Left(UnknownFailure('Failed to get saved user'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSavedUser(LocalUserEntity user) async {
    try {
      await _localDataSource.updateSavedUser(user);
      return const Right(null);
    } catch (_) {
      return Left(UnknownFailure('Failed to update saved user'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedUser() async {
    try {
      await _localDataSource.deleteSavedUser();
      return const Right(null);
    } catch (_) {
      return Left(UnknownFailure('Failed to delete saved user'));
    }
  }
}
