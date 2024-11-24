import 'package:cat_cuisine/router/router.dart';
import 'package:cat_cuisine/screens/cat_hotel_screen.dart';
import 'package:cat_cuisine/screens/detail_screen.dart';
import 'package:cat_cuisine/screens/home_screen.dart';
import 'package:cat_cuisine/screens/settings_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    const FlexScheme usedScheme = FlexScheme.mandyRed;

    return MaterialApp.router(
      routerConfig: router,
      title: 'Cat Cuisine',
      theme: FlexThemeData.light(
        //useMaterial3: true,
        scheme: usedScheme,
        appBarElevation: 0.5,
      ),
      darkTheme: FlexThemeData.dark(
        // useMaterial3: true,
        scheme: usedScheme,
        appBarElevation: 0.5,
      ),
      themeMode: ThemeMode.system,
    );
  }
}

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final ThemeData theme = Theme.of(context);

    final titles = ['Mahlzeiten', 'Katzenhotel', 'Details', 'Einstellungen'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[currentIndex])),
      body: Stack(
        children: [
          Visibility(
            visible: currentIndex == 0,
            maintainState: false,
            child: const HomeScreen(),
          ),
          Visibility(
            visible: currentIndex == 1,
            maintainState: false,
            child: const CatHotelScreen(),
          ),
          Visibility(
            visible: currentIndex == 2,
            maintainState: false,
            child: const DetailScreen(),
          ),
          Visibility(
            visible: currentIndex == 3,
            maintainState: false,
            child: const SettingsScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Mahlzeiten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Katzenhotel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
      ),
    );
  }
}
