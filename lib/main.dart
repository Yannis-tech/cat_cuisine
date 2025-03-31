import 'package:cat_cuisine/main/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qxakcesyialdfflfeoid.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4YWtjZXN5aWFsZGZmbGZlb2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg4MTA2NzUsImV4cCI6MjAzNDM4NjY3NX0.nMyNgHlJBzkMsHjNXP7uZWD_JxzPtbUrdfq934VdBWU',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
