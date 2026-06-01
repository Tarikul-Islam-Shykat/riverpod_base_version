import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/error/failure.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileEntity>> call({
    required String fullName,
    File? image,
  }) {
    return _repository.updateProfile(fullName: fullName, image: image);
  }
}
