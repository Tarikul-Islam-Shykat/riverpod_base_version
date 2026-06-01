import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';

abstract class OtpVerificationRepository {
  Future<Either<Failure, AuthResultEntity>> verifyOtp({
    required String email,
    required String otp,
  });
}
