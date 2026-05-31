import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  GetUsersUseCase(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, List<UserEntity>>> call() {
    return _repository.getUsers();
  }
}
