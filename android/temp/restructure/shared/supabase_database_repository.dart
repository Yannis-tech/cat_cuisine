import 'package:cat_cuisine/shared/domain/repository.dart';
import 'package:cat_cuisine/shared/domain/supabase_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseRepository implements DatabaseRepository {
  final Supabase _supabase;

  const SupabaseDatabaseRepository(this._supabase);

  @override
  Future<List<T>> getAll<T>({
    required SupabaseTable table,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await _supabase.client.from(table.tableName).select();

    return (response as List<dynamic>).map((data) => fromJson(data)).toList();
  }

  @override
  Future<T> getById<T>({
    required SupabaseTable table,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await _supabase.client
        .from(table.tableName)
        .select()
        .eq(table.primaryKey, id)
        .single();

    return fromJson(response);
  }

  @override
  Future<void> delete({
    required SupabaseTable table,
    required String id,
  }) async {
    await _supabase.client
        .from(table.tableName)
        .delete()
        .eq(table.primaryKey, id);
  }

  @override
  Future<T> create<T>({
    required SupabaseTable table,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final createData = {
        ...data,
        'created_at': now,
        'updated_at': now,
      };

      final response = await _supabase.client
          .from(table.tableName)
          .insert(createData)
          .select()
          .single();

      return fromJson(response);
    } catch (e) {
      print('Error creating record: $e');
      rethrow;
    }
  }

  @override
  Future<T> update<T>({
    required SupabaseTable table,
    required String id,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final updateData = {
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase.client
          .from(table.tableName)
          .update(updateData)
          .eq(table.primaryKey, id)
          .select()
          .single();

      return fromJson(response);
    } catch (e) {
      print('Error updating record: $e');
      rethrow;
    }
  }
}
