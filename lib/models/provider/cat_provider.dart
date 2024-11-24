import 'dart:async';
import 'package:cat_cuisine/models/cat_model.dart';
import 'package:cat_cuisine/provider/supabase_provider.dart';
import 'package:cat_cuisine/shared/domain/supabase_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cat_provider.g.dart';

@riverpod
class Cats extends _$Cats {
  @override
  Future<List<CatModel>> build() async {
    final link = ref.keepAlive();
    Timer? timer;

    ref.onDispose(() => timer?.cancel());
    ref.onCancel(() => timer = Timer(const Duration(minutes: 5), link.close));
    ref.onResume(() => timer?.cancel());

    final repository = ref.watch(supabaseRepositoryProvider);
    const table = CatsSupabaseTable();
    return repository.getAll(table: table, fromJson: CatModel.fromJson);
  }

  Future<void> deleteCat(String catId) async {
    final repository = ref.read(supabaseRepositoryProvider);
    const table = CatsSupabaseTable();
    await repository.delete(table: table, id: catId);
    ref.invalidateSelf();
  }

  Future<void> updateCat(CatModel cat) async {
    final repository = ref.read(supabaseRepositoryProvider);
    const table = CatsSupabaseTable();
    await repository.update(
      table: table,
      id: cat.catId,
      data: cat.toJson(),
      fromJson: CatModel.fromJson,
    );
    ref.invalidateSelf();
  }

  Future<void> createCat(CatModel cat) async {
    final repository = ref.read(supabaseRepositoryProvider);
    const table = CatsSupabaseTable();
    await repository.create(
      table: table,
      data: cat.toJson(),
      fromJson: CatModel.fromJson,
    );
    ref.invalidateSelf();
  }
}
