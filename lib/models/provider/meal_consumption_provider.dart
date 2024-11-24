import 'dart:async';
import 'package:cat_cuisine/models/meal_consumption_model.dart';
import 'package:cat_cuisine/provider/supabase_provider.dart';
import 'package:cat_cuisine/shared/domain/supabase_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_consumption_provider.g.dart';

@riverpod
class MealConsumptions extends _$MealConsumptions {
  @override
  Future<List<MealConsumptionModel>> build() async {
    final link = ref.keepAlive();
    Timer? timer;

    ref.onDispose(() => timer?.cancel());
    ref.onCancel(() => timer = Timer(const Duration(minutes: 5), link.close));
    ref.onResume(() => timer?.cancel());

    final repository = ref.watch(supabaseRepositoryProvider);
    const table = MealConsumptionsSupabaseTable();
    return repository.getAll(
        table: table, fromJson: MealConsumptionModel.fromJson);
  }

  Future<void> createConsumption(MealConsumptionModel consumption) async {
    final repository = ref.read(supabaseRepositoryProvider);
    const table = MealConsumptionsSupabaseTable();
    await repository.create(
      table: table,
      data: consumption.toJson(),
      fromJson: MealConsumptionModel.fromJson,
    );
    ref.invalidateSelf();
  }

  Future<void> updateConsumption(MealConsumptionModel consumption) async {
    if (consumption.mealConsumptionId == null) {
      throw Exception('Cannot update meal without ID');
    }

    final repository = ref.read(supabaseRepositoryProvider);
    const table = MealConsumptionsSupabaseTable();
    await repository.update(
      table: table,
      id: consumption.mealConsumptionId!,
      data: consumption.toJson(),
      fromJson: MealConsumptionModel.fromJson,
    );
    ref.invalidateSelf();
  }

  Future<void> deleteConsumption(String id) async {
    final repository = ref.read(supabaseRepositoryProvider);
    const table = MealConsumptionsSupabaseTable();
    await repository.delete(table: table, id: id);
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<MealConsumptionModel>> mealConsumptionsForMeal(
    MealConsumptionsForMealRef ref, String? mealId) async {
  final consumptions = await ref.watch(mealConsumptionsProvider.future);
  return consumptions.where((c) => c.mealId == mealId).toList();
}
