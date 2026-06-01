import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../repositories/otp_verification_repository.dart';

class VerifyOtpUseCase {
  VerifyOtpUseCase(this._repository);

  final OtpVerificationRepository _repository;

  Future<Either<Failure, AuthResultEntity>> call({
    required String email,
    required String otp,
  }) {
    return _repository.verifyOtp(email: email, otp: otp);
  }
}
