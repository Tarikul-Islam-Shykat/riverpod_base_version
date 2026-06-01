import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/constants/endpoinst.dart';
import '../../../../../core/services/network/error/failure.dart';
import '../../../../../core/services/network/service/network_service.dart';
import '../../models/profile_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, ProfileModel>> getProfile() async {
    final result = await _networkService.get<Map<String, dynamic>>(
      AppEndpoints.profile,
      isAuth: true,
    );

    return result.map((response) {
      final data = response['data'];
      return ProfileModel.fromJson(
        data is Map<String, dynamic> ? data : <String, dynamic>{},
      );
    });
  }

  Future<Either<Failure, ProfileModel>> updateProfile({
    required String fullName,
    File? image,
  }) async {
    final result = await _networkService.multipartRequest<Map<String, dynamic>>(
      AppEndpoints.profile,
      method: RequestMethod.put,
      data: {
        'fullName': fullName,
      },
      files: image == null ? null : {'image': image},
      isAuth: true,
    );

    return result.map((response) {
      final data = response['data'];
      return ProfileModel.fromJson(
        data is Map<String, dynamic> ? data : <String, dynamic>{},
      );
    });
  }
}

final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return ProfileRemoteDataSource(networkService);
});
