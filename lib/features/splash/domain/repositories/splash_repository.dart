import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/splash_session_entity.dart';

abstract class SplashRepository {
  Future<Either<Failure, SplashSessionEntity>> resolveSession();
}
