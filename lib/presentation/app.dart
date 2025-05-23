import 'package:cat_cuisine/core/configs/themes.dart';
import 'package:cat_cuisine/core/router/router.dart';
import 'package:flutter/material.dart';

class CatCuisineApp extends StatelessWidget {
  const CatCuisineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cat Cuisine',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}