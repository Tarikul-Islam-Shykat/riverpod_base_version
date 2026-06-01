import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/services/local_storage_service/secure/secure_storage.dart';
import '../../../../shared/domain/entities/auth_result_entity.dart';

class LoginLocalDataSource {
  LoginLocalDataSource(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  Future<void> saveSession(AuthResultEntity result) async {
    if (result.token != null && result.token!.isNotEmpty) {
      await _secureStorageService.setToken(result.token!);
    }
    if (result.role != null && result.role!.isNotEmpty) {
      await _secureStorageService.write('role', result.role!);
    }
    if (result.email != null && result.email!.isNotEmpty) {
      await _secureStorageService.write('email', result.email!);
    }
  }
}

final loginLocalDataSourceProvider = Provider<LoginLocalDataSource>((ref) {
  final secureStorageService = ref.read(secureStorageServiceProvider);
  return LoginLocalDataSource(secureStorageService);
});
