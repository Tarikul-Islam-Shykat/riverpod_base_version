import 'package:go_router/go_router.dart';

import '../../features/auth/forgot_password/presentation/pages/forgot_password_page.dart';
import '../../features/auth/login/presentation/pages/login_page.dart';
import '../../features/auth/otp_verification/presentation/pages/otp_verification_page.dart';
import '../../features/auth/reset_password/presentation/pages/reset_password_page.dart';
import '../../features/auth/sign_up/presentation/pages/sign_up_page.dart';
import '../../features/example/get-post-feature/presentation/pages/posts_page.dart';
import '../../features/example/home/presentation/pages/home_shell_page.dart';
import '../../features/example/get-user-feature/presentation/pages/users_page.dart';
import '../../features/example/todo-feature/presentation/pages/todo_page.dart';
import '../../features/example/social-post-feature/presentation/pages/social_posts_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String posts = '/posts';
  static const String users = '/users';
  static const String todo = '/todo';
  static const String socialPosts = '/social-posts';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeShellPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        final purpose = state.uri.queryParameters['purpose'] ?? 'signUp';
        return OtpVerificationPage(email: email, purpose: purpose);
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return ResetPasswordPage(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.posts,
      builder: (context, state) => const PostsPage(),
    ),
    GoRoute(
      path: AppRoutes.users,
      builder: (context, state) => const UsersPage(),
    ),
    GoRoute(
      path: AppRoutes.todo,
      builder: (context, state) => const TodoPage(),
    ),
    GoRoute(
      path: AppRoutes.socialPosts,
      builder: (context, state) => const SocialPostsPage(),
    ),
  ],
);
