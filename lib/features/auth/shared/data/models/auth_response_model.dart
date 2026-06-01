import '../../domain/entities/auth_result_entity.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.message,
    this.token,
    this.role,
    this.email,
  });

  final bool success;
  final String message;
  final String? token;
  final String? role;
  final String? email;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    return AuthResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      token: _readString(dataMap, ['token', 'accessToken', 'access_token']) ??
          _readString(json, ['token', 'accessToken', 'access_token']),
      role: _readString(dataMap, ['role']) ?? _readString(json, ['role']),
      email: _readString(dataMap, ['email']) ?? _readString(json, ['email']),
    );
  }

  AuthResultEntity toEntity() {
    return AuthResultEntity(
      success: success,
      message: message,
      token: token,
      role: role,
      email: email,
    );
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }

    return null;
  }
}
