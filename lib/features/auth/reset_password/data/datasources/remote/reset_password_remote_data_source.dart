import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/constants/endpoinst.dart';
import '../../../../../../core/services/network/error/failure.dart';
import '../../../../../../core/services/network/service/network_service.dart';
import '../../../../shared/data/models/auth_response_model.dart';

class ResetPasswordRemoteDataSource {
  ResetPasswordRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, AuthResponseModel>> resetPassword({
    required String email,
    required String password,
  }) async {
    final result = await _networkService.post<Map<String, dynamic>>(
      AppEndpoints.resetPassword,
      data: {
        'email': email,
        'password': password,
      },
    );

    return result.map(AuthResponseModel.fromJson);
  }
}

final resetPasswordRemoteDataSourceProvider =
    Provider<ResetPasswordRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return ResetPasswordRemoteDataSource(networkService);
});
