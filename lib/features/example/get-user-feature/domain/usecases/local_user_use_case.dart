import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/local_user_entity.dart';
import '../repositories/user_repository.dart';

class LocalUserUseCase {
  LocalUserUseCase(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, void>> saveUser(LocalUserEntity user) {
    return _repository.saveUser(user);
  }

  Future<Either<Failure, LocalUserEntity?>> getSavedUser() {
    return _repository.getSavedUser();
  }

  Future<Either<Failure, void>> updateSavedUser(LocalUserEntity user) {
    return _repository.updateSavedUser(user);
  }

  Future<Either<Failure, void>> deleteSavedUser() {
    return _repository.deleteSavedUser();
  }
}
