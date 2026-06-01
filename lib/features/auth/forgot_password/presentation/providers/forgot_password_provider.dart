import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/remote/forgot_password_remote_data_source.dart';
import '../../data/repositories/forgot_password_repository_impl.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../../domain/usecases/request_password_reset_otp_use_case.dart';

final forgotPasswordRepositoryProvider =
    Provider<ForgotPasswordRepository>((ref) {
  final remoteDataSource = ref.read(forgotPasswordRemoteDataSourceProvider);
  return ForgotPasswordRepositoryImpl(remoteDataSource);
});

final requestPasswordResetOtpUseCaseProvider =
    Provider<RequestPasswordResetOtpUseCase>((ref) {
  final repository = ref.read(forgotPasswordRepositoryProvider);
  return RequestPasswordResetOtpUseCase(repository);
});
