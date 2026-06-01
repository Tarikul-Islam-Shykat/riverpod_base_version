import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../repositories/sign_up_repository.dart';

class SignUpUseCase {
  SignUpUseCase(this._repository);

  final SignUpRepository _repository;

  Future<Either<Failure, AuthResultEntity>> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
