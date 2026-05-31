import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    final result = await _remoteDataSource.getUsers();

    return result.map(
      (users) => users.map((user) => user.toEntity()).toList(growable: false),
    );
  }
}
