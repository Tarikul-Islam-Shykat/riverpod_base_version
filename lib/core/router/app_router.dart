import 'package:go_router/go_router.dart';

import '../../features/example/get-feature/presentation/pages/posts_page.dart';
import '../../features/example/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String posts = '/posts';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.posts,
      builder: (context, state) => const PostsPage(),
    ),
  ],
);
