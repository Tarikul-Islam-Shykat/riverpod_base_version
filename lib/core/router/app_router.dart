import 'package:go_router/go_router.dart';

import '../../features/example/get-post-feature/presentation/pages/posts_page.dart';
import '../../features/example/home/presentation/pages/home_shell_page.dart';
import '../../features/example/get-user-feature/presentation/pages/users_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String posts = '/posts';
  static const String users = '/users';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeShellPage(),
    ),
    GoRoute(
      path: AppRoutes.posts,
      builder: (context, state) => const PostsPage(),
    ),
    GoRoute(
      path: AppRoutes.users,
      builder: (context, state) => const UsersPage(),
    ),
  ],
);
