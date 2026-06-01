import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/remote/forgot_password_remote_data_source.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  ForgotPasswordRepositoryImpl(this._remoteDataSource);

  final ForgotPasswordRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthResultEntity>> requestOtp(String email) async {
    final result = await _remoteDataSource.requestOtp(email);
    return result.map((response) => response.toEntity());
  }
}
