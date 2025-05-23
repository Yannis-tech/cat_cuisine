import 'package:cat_cuisine/main/my_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Holds the state for the currently selected index of the navbar
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainScreen(),
      ),
    ],
  );
});
