import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/error/failure.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return result.map((profile) => profile.toEntity());
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String fullName,
    File? image,
  }) async {
    final result = await _remoteDataSource.updateProfile(
      fullName: fullName,
      image: image,
    );

    return result.map((profile) => profile.toEntity());
  }
}
