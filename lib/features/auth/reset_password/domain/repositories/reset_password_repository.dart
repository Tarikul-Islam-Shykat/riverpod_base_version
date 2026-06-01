import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, AuthResultEntity>> resetPassword({
    required String email,
    required String password,
  });
}
