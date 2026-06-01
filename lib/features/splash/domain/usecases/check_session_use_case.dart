import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/splash_session_entity.dart';
import '../repositories/splash_repository.dart';

class CheckSessionUseCase {
  CheckSessionUseCase(this._repository);

  final SplashRepository _repository;

  Future<Either<Failure, SplashSessionEntity>> call() {
    return _repository.resolveSession();
  }
}
