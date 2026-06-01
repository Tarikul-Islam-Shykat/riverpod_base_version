import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/constants/endpoinst.dart';
import '../../../../../../core/services/network/error/failure.dart';
import '../../../../../../core/services/network/service/network_service.dart';
import '../../../../shared/data/models/auth_response_model.dart';

class ForgotPasswordRemoteDataSource {
  ForgotPasswordRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, AuthResponseModel>> requestOtp(String email) async {
    final result = await _networkService.post<Map<String, dynamic>>(
      AppEndpoints.forgotPassword,
      data: {'email': email},
    );

    return result.map(AuthResponseModel.fromJson);
  }
}

final forgotPasswordRemoteDataSourceProvider =
    Provider<ForgotPasswordRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return ForgotPasswordRemoteDataSource(networkService);
});
