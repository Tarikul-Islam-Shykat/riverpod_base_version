import 'package:fpdart/fpdart.dart';

import '../../../../../core/constants/endpoinst.dart';
import '../../../../../core/services/network/error/failure.dart';
import '../../../../../core/services/network/service/network_service.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  UserRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, List<UserModel>>> getUsers() async {
    final result = await _networkService.get<List<dynamic>>(
      AppEndpoints.jsonPlaceholderUsers,
    );

    return result.map(
      (response) {
        return response
            .whereType<Map>()
            .map((item) => UserModel.fromJson(Map<String, dynamic>.from(item)))
            .toList(growable: false);
      },
    );
  }
}
