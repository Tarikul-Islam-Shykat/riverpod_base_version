import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/constants/endpoinst.dart';
import '../../../../../../core/services/network/error/failure.dart';
import '../../../../../../core/services/network/service/network_service.dart';

class SplashRemoteDataSource {
  SplashRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, Map<String, dynamic>>> fetchProfile() async {
    final result = await _networkService.get<Map<String, dynamic>>(
      AppEndpoints.profile,
      isAuth: true,
    );

    return result;
  }
}

final splashRemoteDataSourceProvider = Provider<SplashRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return SplashRemoteDataSource(networkService);
});
