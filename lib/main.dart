import 'package:cat_cuisine/main/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qxakcesyialdfflfeoid.supabase.co',
    anonKey: 'hidden',
  );

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
