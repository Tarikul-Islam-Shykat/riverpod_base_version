import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, AuthResultEntity>> login({
    required String email,
    required String password,
  });
}
