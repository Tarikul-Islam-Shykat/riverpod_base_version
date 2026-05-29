import 'package:dio/dio.dart';

import '../../local_storage_service/secure/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final bool isAuth = options.extra['isAuth'] ?? false;

    if (isAuth) {
      final token = await _secureStorage.getToken();
      if (token != null) {
        options.headers['Authorization'] = token;
      }
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
    }
    super.onError(err, handler);
  }
}
