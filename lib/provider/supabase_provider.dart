import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cat_cuisine/shared/supabase_database_repository.dart';
import 'package:cat_cuisine/shared/domain/supabase_table.dart';

part 'supabase_provider.g.dart';

@riverpod
CatsSupabaseTable catsTable(CatsTableRef ref) {
  return const CatsSupabaseTable();
}

@riverpod
SupabaseDatabaseRepository supabaseRepository(SupabaseRepositoryRef ref) {
  return SupabaseDatabaseRepository(Supabase.instance);
}
