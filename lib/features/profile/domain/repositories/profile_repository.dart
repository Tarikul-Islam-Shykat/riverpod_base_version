import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/error/failure.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String fullName,
    File? image,
  });
}
