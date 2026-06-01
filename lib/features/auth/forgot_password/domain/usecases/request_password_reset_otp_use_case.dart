import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../repositories/forgot_password_repository.dart';

class RequestPasswordResetOtpUseCase {
  RequestPasswordResetOtpUseCase(this._repository);

  final ForgotPasswordRepository _repository;

  Future<Either<Failure, AuthResultEntity>> call(String email) {
    return _repository.requestOtp(email);
  }
}
