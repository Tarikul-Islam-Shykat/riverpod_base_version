import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../domain/entities/splash_session_entity.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/local/splash_local_data_source.dart';
import '../datasources/remote/splash_remote_data_source.dart';

class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl({
    required SplashLocalDataSource localDataSource,
    required SplashRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final SplashLocalDataSource _localDataSource;
  final SplashRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, SplashSessionEntity>> resolveSession() async {
    try {
      final token = await _localDataSource.getToken();
      if (token == null || token.isEmpty) {
        return const Right(SplashSessionEntity(isAuthenticated: false));
      }

      final profileResult = await _remoteDataSource.fetchProfile();
      return profileResult.fold(
        (failure) async {
          await _localDataSource.clearSession();
          return const Right(SplashSessionEntity(isAuthenticated: false));
        },
        (profile) async {
          final isSuccess = profile['success'] == true;
          final data = profile['data'];
          final role = data is Map<String, dynamic> ? data['role'] as String? : null;

          if (!isSuccess) {
            await _localDataSource.clearSession();
            return const Right(SplashSessionEntity(isAuthenticated: false));
          }

          if (role != null && role.isNotEmpty) {
            await _localDataSource.saveRole(role);
          }

          return Right(
            SplashSessionEntity(
              isAuthenticated: true,
              role: role ?? await _localDataSource.getRole(),
            ),
          );
        },
      );
    } catch (_) {
      await _localDataSource.clearSession();
      return const Right(SplashSessionEntity(isAuthenticated: false));
    }
  }
}
