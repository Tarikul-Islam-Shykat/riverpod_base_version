import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/remote/otp_verification_remote_data_source.dart';
import '../../data/repositories/otp_verification_repository_impl.dart';
import '../../domain/repositories/otp_verification_repository.dart';
import '../../domain/usecases/verify_otp_use_case.dart';

final otpVerificationRepositoryProvider =
    Provider<OtpVerificationRepository>((ref) {
  final remoteDataSource = ref.read(otpVerificationRemoteDataSourceProvider);
  return OtpVerificationRepositoryImpl(remoteDataSource);
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final repository = ref.read(otpVerificationRepositoryProvider);
  return VerifyOtpUseCase(repository);
});
