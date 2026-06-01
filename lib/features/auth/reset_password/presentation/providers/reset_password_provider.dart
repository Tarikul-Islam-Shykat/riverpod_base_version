import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/remote/reset_password_remote_data_source.dart';
import '../../data/repositories/reset_password_repository_impl.dart';
import '../../domain/repositories/reset_password_repository.dart';
import '../../domain/usecases/reset_password_use_case.dart';

final resetPasswordRepositoryProvider =
    Provider<ResetPasswordRepository>((ref) {
  final remoteDataSource = ref.read(resetPasswordRemoteDataSourceProvider);
  return ResetPasswordRepositoryImpl(remoteDataSource);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repository = ref.read(resetPasswordRepositoryProvider);
  return ResetPasswordUseCase(repository);
});
