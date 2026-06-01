import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';

abstract class SignUpRepository {
  Future<Either<Failure, AuthResultEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  });
}
