import 'dart:async';
import 'package:cat_cuisine/models/meal_model.dart';
import 'package:cat_cuisine/provider/supabase_provider.dart';
import 'package:cat_cuisine/shared/domain/supabase_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_provider.g.dart';

@riverpod
class Meals extends _$Meals {
  @override
  Future<List<MealModel>> build() async {
    final link = ref.keepAlive();
    Timer? timer;

    ref.onDispose(() => timer?.cancel());
    ref.onCancel(() => timer = Timer(const Duration(minutes: 5), link.close));
    ref.onResume(() => timer?.cancel());

    final repository = ref.watch(supabaseRepositoryProvider);
    const table = MealsSupabaseTable();
    return repository.getAll(table: table, fromJson: MealModel.fromJson);
  }

  Future<void> deleteMeal(String mealId) async {
    final repository = ref.read(supabaseRepositoryProvider);
    const table = MealsSupabaseTable();
    await repository.delete(table: table, id: mealId);
    ref.invalidateSelf();
  }

  Future<MealModel> createMeal(MealModel meal) async {
    final repository = ref.read(supabaseRepositoryProvider);
    const table = MealsSupabaseTable();
    final createdMeal = await repository.create(
      table: table,
      data: meal.toJson(),
      fromJson: MealModel.fromJson,
    );
    ref.invalidateSelf();
    return createdMeal; // Return the created meal
  }

  Future<MealModel> updateMeal(MealModel meal) async {
    if (meal.mealId == null) {
      throw Exception('Cannot update meal without ID');
    }

    final repository = ref.read(supabaseRepositoryProvider);
    const table = MealsSupabaseTable();
    final updatedMeal = await repository.update(
      table: table,
      id: meal.mealId!,
      data: meal.toJson(),
      fromJson: MealModel.fromJson,
    );
    ref.invalidateSelf();
    return updatedMeal; // Return the updated meal
  }
}
