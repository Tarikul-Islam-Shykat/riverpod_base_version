import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../../domain/repositories/reset_password_repository.dart';
import '../datasources/remote/reset_password_remote_data_source.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  ResetPasswordRepositoryImpl(this._remoteDataSource);

  final ResetPasswordRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthResultEntity>> resetPassword({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.resetPassword(
      email: email,
      password: password,
    );

    return result.map((response) => response.toEntity());
  }
}
