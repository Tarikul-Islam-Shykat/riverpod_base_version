import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/remote/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.read(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource);
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateProfileUseCase(repository);
});

final profileProvider = FutureProvider.autoDispose<ProfileEntity>((ref) async {
  final useCase = ref.read(getProfileUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (profile) => profile,
  );
});

class UpdateProfilePayload {
  const UpdateProfilePayload({
    required this.fullName,
    this.image,
  });

  final String fullName;
  final File? image;
}

final updateProfileProvider =
    FutureProvider.autoDispose.family<ProfileEntity, UpdateProfilePayload>(
  (ref, payload) async {
    final useCase = ref.read(updateProfileUseCaseProvider);
    final result = await useCase(
      fullName: payload.fullName,
      image: payload.image,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (profile) => profile,
    );
  },
);
