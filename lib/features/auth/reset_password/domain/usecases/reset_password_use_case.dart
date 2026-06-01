import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../repositories/reset_password_repository.dart';

class ResetPasswordUseCase {
  ResetPasswordUseCase(this._repository);

  final ResetPasswordRepository _repository;

  Future<Either<Failure, AuthResultEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.resetPassword(email: email, password: password);
  }
}
