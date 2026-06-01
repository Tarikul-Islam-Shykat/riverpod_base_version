import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, AuthResultEntity>> requestOtp(String email);
}
