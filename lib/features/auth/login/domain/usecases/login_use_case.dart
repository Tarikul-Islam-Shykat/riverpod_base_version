import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../repositories/login_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final LoginRepository _repository;

  Future<Either<Failure, AuthResultEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
