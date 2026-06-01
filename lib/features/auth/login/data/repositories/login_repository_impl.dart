import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/local/login_local_data_source.dart';
import '../datasources/remote/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    required LoginRemoteDataSource remoteDataSource,
    required LoginLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final LoginRemoteDataSource _remoteDataSource;
  final LoginLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, AuthResultEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    return result.fold(
      Left.new,
      (response) async {
        final entity = response.toEntity();
        if (entity.success) {
          await _localDataSource.saveSession(entity);
        }

        return Right(entity);
      },
    );
  }
}
