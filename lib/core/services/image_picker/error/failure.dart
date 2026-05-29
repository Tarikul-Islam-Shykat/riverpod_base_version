abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = "Server error occurred"]);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = "No internet connection"]);
}

class AuthFailure extends Failure {
  AuthFailure([super.message = "Authentication failed"]);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

class ImagePickFailure extends Failure {
  ImagePickFailure([super.message = "Failed to pick image"]);
}

class CompressionFailure extends Failure {
  CompressionFailure([super.message = "Failed to compress image"]);
}

class UnknownFailure extends Failure {
  UnknownFailure([super.message = "An unknown error occurred"]);
}
