import 'package:cat_cuisine/core/configs/api.dart';
import 'package:cat_cuisine/presentation/app.dart';
import 'package:cat_cuisine/core/di/injection.dart';
import 'package:cat_cuisine/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLogger();

   await _initializeSupabase();

   configureDependencyInjection();

  runApp(
    const CatCuisineApp()
  );
}

Future<void> _initializeSupabase() async {
  await Supabase.initialize(
     url: ApiConfig.url,
    anonKey: ApiConfig.anonKey,
  );
}
