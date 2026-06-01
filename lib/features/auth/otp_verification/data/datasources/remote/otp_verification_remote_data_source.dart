import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/constants/endpoinst.dart';
import '../../../../../../core/services/network/error/failure.dart';
import '../../../../../../core/services/network/service/network_service.dart';
import '../../../../shared/data/models/auth_response_model.dart';

class OtpVerificationRemoteDataSource {
  OtpVerificationRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, AuthResponseModel>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final result = await _networkService.post<Map<String, dynamic>>(
      AppEndpoints.verifyOtp,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    return result.map(AuthResponseModel.fromJson);
  }
}

final otpVerificationRemoteDataSourceProvider =
    Provider<OtpVerificationRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return OtpVerificationRemoteDataSource(networkService);
});
