import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/constants/endpoinst.dart';
import '../../../../../../core/services/network/error/failure.dart';
import '../../../../../../core/services/network/service/network_service.dart';
import '../../../../shared/data/models/auth_response_model.dart';

class SignUpRemoteDataSource {
  SignUpRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, AuthResponseModel>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await _networkService.post<Map<String, dynamic>>(
      AppEndpoints.register,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
      },
    );

    return result.map(AuthResponseModel.fromJson);
  }
}

final signUpRemoteDataSourceProvider =
    Provider<SignUpRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return SignUpRemoteDataSource(networkService);
});
