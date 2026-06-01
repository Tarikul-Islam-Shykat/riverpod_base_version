import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../../shared/domain/entities/auth_result_entity.dart';
import '../../domain/repositories/otp_verification_repository.dart';
import '../datasources/remote/otp_verification_remote_data_source.dart';

class OtpVerificationRepositoryImpl implements OtpVerificationRepository {
  OtpVerificationRepositoryImpl(this._remoteDataSource);

  final OtpVerificationRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthResultEntity>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final result = await _remoteDataSource.verifyOtp(email: email, otp: otp);
    return result.map((response) => response.toEntity());
  }
}
