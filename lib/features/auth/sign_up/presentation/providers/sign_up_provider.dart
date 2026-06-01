import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/remote/sign_up_remote_data_source.dart';
import '../../data/repositories/sign_up_repository_impl.dart';
import '../../domain/repositories/sign_up_repository.dart';
import '../../domain/usecases/sign_up_use_case.dart';

final signUpRepositoryProvider = Provider<SignUpRepository>((ref) {
  final remoteDataSource = ref.read(signUpRemoteDataSourceProvider);
  return SignUpRepositoryImpl(remoteDataSource);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.read(signUpRepositoryProvider);
  return SignUpUseCase(repository);
});
