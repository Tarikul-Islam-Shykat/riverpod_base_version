import 'package:dio/dio.dart';

import '../../image_picker/error/failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return UnknownFailure(error.toString());
  }

  static Failure _handleDioError(DioException e) {
    if (e.response != null) {
      return _handleErrorResponse(e.response!);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure("Connection timed out");
      case DioExceptionType.connectionError:
        return NetworkFailure("No internet connection");
      default:
        return NetworkFailure(e.message ?? "Network error occurred");
    }
  }

  static Failure _handleErrorResponse(Response response) {
    final data = response.data;
    String message = "Something went wrong";
    
    if (data is Map) {
      message = data['message'] ?? data['error'] ?? message;
    }

    switch (response.statusCode) {
      case 401:
        return AuthFailure(message);
      case 400:
        return ValidationFailure(message);
      case 404:
        return ServerFailure("Resource not found");
      case 500:
        return ServerFailure("Internal server error");
      default:
        return ServerFailure(message);
    }
  }
}
