import 'package:cat_cuisine/core/router/routes.dart';
import 'package:cat_cuisine/presentation/views/home/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.initial.name,
      path: Routes.initial.path,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      name: Routes.home.name,
      path: Routes.home.path,
      builder: (context, state) => const HomeScreen(),
    ),
    /*
    GoRoute(
      name: Routes.settings.name,
      path: Routes.settings.path,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      name: Routes.changeEmailAddress.name,
      path: Routes.changeEmailAddress.path,
      builder: (context, state) => const ChangeEmailAddressPage(),
    ),
    GoRoute(
      name: Routes.themeMode.name,
      path: Routes.themeMode.path,
      builder: (context, state) => const ThemeModePage(),
    ),
    */
  ],
);
}