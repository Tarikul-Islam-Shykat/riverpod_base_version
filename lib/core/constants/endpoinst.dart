import '../env/env.dart';

class AppEndpoints {
  static const String jsonPlaceholderPosts =
      'https://jsonplaceholder.typicode.com/posts';
  static const String jsonPlaceholderUsers =
      'https://jsonplaceholder.typicode.com/users';
  static const String jsonPlaceholderComments =
      'https://jsonplaceholder.typicode.com/comments';
  static const String login = '${Env.baseUrl}/auth/login';
  static const String register = '${Env.baseUrl}/users';
  static const String signUp = '${Env.baseUrl}/users/register';
  static const String forgotPassword = '${Env.baseUrl}/auth/forgot-password';
  static const String verifyOtp = '${Env.baseUrl}/auth/verify-otp';
  static const String resetPassword = '${Env.baseUrl}/auth/reset-password';
  static const String changePassword = '${Env.baseUrl}/auth/change-password';
  static const String profile = '${Env.baseUrl}/users/profile';
}
