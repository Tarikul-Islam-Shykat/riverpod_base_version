import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../../domain/repositories/sign_up_repository.dart';
import '../datasources/remote/sign_up_remote_data_source.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  SignUpRepositoryImpl(this._remoteDataSource);

  final SignUpRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthResultEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );

    return result.map((response) => response.toEntity());
  }
}
