import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/services/local_storage_service/secure/secure_storage.dart';

class SplashLocalDataSource {
  SplashLocalDataSource(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  Future<String?> getToken() {
    return _secureStorageService.getToken();
  }

  Future<String?> getRole() {
    return _secureStorageService.read('role');
  }

  Future<void> saveRole(String role) {
    return _secureStorageService.write('role', role);
  }

  Future<void> clearSession() {
    return Future.wait([
      _secureStorageService.deleteToken(),
      _secureStorageService.delete('role'),
    ]).then((_) {});
  }
}

final splashLocalDataSourceProvider = Provider<SplashLocalDataSource>((ref) {
  final secureStorageService = ref.read(secureStorageServiceProvider);
  return SplashLocalDataSource(secureStorageService);
});
