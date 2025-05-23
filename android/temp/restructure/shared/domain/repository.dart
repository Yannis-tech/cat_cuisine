import 'package:cat_cuisine/shared/domain/supabase_table.dart';

abstract class DatabaseRepository {
  Future<List<T>> getAll<T>({
    required SupabaseTable table,
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<T> getById<T>({
    required SupabaseTable table,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<void> delete({
    required SupabaseTable table,
    required String id,
  });

  Future<T> create<T>({
    required SupabaseTable table,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<T> update<T>({
    required SupabaseTable table,
    required String id,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  });
}
