import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/error/failure.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileEntity>> call() {
    return _repository.getProfile();
  }
}
