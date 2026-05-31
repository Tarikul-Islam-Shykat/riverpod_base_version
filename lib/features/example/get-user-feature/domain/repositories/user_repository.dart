import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/local_user_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();

  Future<Either<Failure, void>> saveUser(LocalUserEntity user);

  Future<Either<Failure, LocalUserEntity?>> getSavedUser();

  Future<Either<Failure, void>> updateSavedUser(LocalUserEntity user);

  Future<Either<Failure, void>> deleteSavedUser();
}
