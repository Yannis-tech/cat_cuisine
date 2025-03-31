import 'package:cat_cuisine/forms/provider/meal_consumption_form_provider.dart';
import 'package:cat_cuisine/models/meal_model.dart';
import 'package:cat_cuisine/models/provider/food_database_provider.dart';
import 'package:cat_cuisine/models/provider/meal_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_form_provider.g.dart';

class MealFormState {
  final TextEditingController portionController;
  final String? brand;
  final String? productLine;
  final String? sort;
  final String? packaging;
  final String? packagingSize;
  final DateTime? timeOfDay;
  final int? portionSize;

  final List<String> availableProductLines;
  final List<String> availableSorts;
  final List<String> availablePackagings;
  final List<String> availablePackagingSizes;

  final bool isLoadingProductLines;
  final bool isLoadingSorts;
  final bool isLoadingPackagings;
  final bool isLoadingPackagingSizes;

  final bool isSaving;
  final String? error;
  final bool isLoading;

  MealFormState({
    this.brand,
    this.productLine,
    this.sort,
    this.packaging,
    this.packagingSize,
    this.timeOfDay,
    this.portionSize,
    this.availableProductLines = const [],
    this.availableSorts = const [],
    this.availablePackagings = const [],
    this.availablePackagingSizes = const [],
    this.isLoadingProductLines = false,
    this.isLoadingSorts = false,
    this.isLoadingPackagings = false,
    this.isLoadingPackagingSizes = false,
    this.isSaving = false,
    this.error,
    this.isLoading = false,
  }) : portionController =
            TextEditingController(text: portionSize?.toString() ?? '');

  MealFormState copyWith({
    String? brand,
    String? productLine,
    String? sort,
    String? packaging,
    String? packagingSize,
    DateTime? timeOfDay,
    int? portionSize,
    List<String>? availableProductLines,
    List<String>? availableSorts,
    List<String>? availablePackagings,
    List<String>? availablePackagingSizes,
    bool? isLoadingProductLines,
    bool? isLoadingSorts,
    bool? isLoadingPackagings,
    bool? isLoadingPackagingSizes,
    bool? isSaving,
    String? error,
    bool? isLoading,
  }) {
    return MealFormState(
      brand: brand ?? this.brand,
      productLine: productLine ?? this.productLine,
      sort: sort ?? this.sort,
      packaging: packaging ?? this.packaging,
      packagingSize: packagingSize ?? this.packagingSize,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      portionSize: portionSize ?? this.portionSize,
      availableProductLines:
          availableProductLines ?? this.availableProductLines,
      availableSorts: availableSorts ?? this.availableSorts,
      availablePackagings: availablePackagings ?? this.availablePackagings,
      availablePackagingSizes:
          availablePackagingSizes ?? this.availablePackagingSizes,
      isLoadingProductLines:
          isLoadingProductLines ?? this.isLoadingProductLines,
      isLoadingSorts: isLoadingSorts ?? this.isLoadingSorts,
      isLoadingPackagings: isLoadingPackagings ?? this.isLoadingPackagings,
      isLoadingPackagingSizes:
          isLoadingPackagingSizes ?? this.isLoadingPackagingSizes,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  MealModel toMealModel() {
    return MealModel(
      timeOfDay: timeOfDay ?? DateTime.now(),
      brandName: brand ?? '',
      sortName: sort ?? '',
      productLine: productLine ?? '',
      foodType: 'Nassfutter', // Hardcoded as all entries are wet food
      packaging: packaging ?? '',
      packagingSize: int.tryParse(
              packagingSize?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ??
          0,
      portionSize: portionSize ?? 0,
    );
  }
}

@riverpod
class MealForm extends _$MealForm {
  @override
  FutureOr<MealFormState> build(MealModel? initialMeal) async {
    final initialState = MealFormState(
      brand: initialMeal?.brandName,
      productLine: initialMeal?.productLine,
      sort: initialMeal?.sortName,
      packaging: initialMeal?.packaging,
      packagingSize: initialMeal?.packagingSize.toString(),
      timeOfDay: initialMeal?.timeOfDay,
      portionSize: initialMeal?.portionSize,
      isLoading: true,
    );

    final foodData = await ref.read(foodDataProvider.future);
    return initialState.copyWith(
      availableProductLines: foodData.map((e) => e.productLine).toSet().toList()
        ..sort(),
      availableSorts: foodData.map((e) => e.sort).toSet().toList()..sort(),
      availablePackagings: foodData.map((e) => e.packaging).toSet().toList()
        ..sort(),
      availablePackagingSizes:
          foodData.map((e) => e.packagingSize).toSet().toList()..sort(),
      isLoading: false,
    );
  }

  Future<void> updateFilters(MealFormState newState) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final foodData = await ref.read(foodDataProvider.future);
      final filteredItems = foodData
          .where((item) =>
              (newState.brand == null || item.brand == newState.brand) &&
              (newState.productLine == null ||
                  item.productLine == newState.productLine) &&
              (newState.sort == null || item.sort == newState.sort) &&
              (newState.packaging == null ||
                  item.packaging == newState.packaging) &&
              (newState.packagingSize == null ||
                  item.packagingSize == newState.packagingSize))
          .toList();

      return newState.copyWith(
        availableProductLines:
            filteredItems.map((e) => e.productLine).toSet().toList()..sort(),
        availableSorts: filteredItems.map((e) => e.sort).toSet().toList()
          ..sort(),
        availablePackagings:
            filteredItems.map((e) => e.packaging).toSet().toList()..sort(),
        availablePackagingSizes:
            filteredItems.map((e) => e.packagingSize).toSet().toList()..sort(),
        isLoading: false,
      );
    });
  }

  Future<void> setBrand(String? brand) async {
    if (state.hasValue) {
      final newState = state.value!.copyWith(brand: brand);
      await updateFilters(newState);

      if (brand != null &&
          !state.value!.availableProductLines
              .contains(state.value!.productLine)) {
        await setProductLine(null);
      }
    }
  }

  Future<void> setProductLine(String? productLine) async {
    if (state.hasValue) {
      final newState = state.value!.copyWith(productLine: productLine);
      await updateFilters(newState);

      if (productLine != null &&
          !state.value!.availableSorts.contains(state.value!.sort)) {
        await setSort(null);
      }
    }
  }

  Future<void> setSort(String? sort) async {
    if (state.hasValue) {
      final newState = state.value!.copyWith(sort: sort);
      await updateFilters(newState);

      if (sort != null &&
          !state.value!.availablePackagings.contains(state.value!.packaging)) {
        await setPackaging(null);
      }
    }
  }

  Future<void> setPackaging(String? packaging) async {
    if (state.hasValue) {
      final newState = state.value!.copyWith(packaging: packaging);
      await updateFilters(newState);

      if (packaging != null &&
          !state.value!.availablePackagingSizes
              .contains(state.value!.packagingSize)) {
        await setPackagingSize(null);
      }
    }
  }

  Future<void> setPackagingSize(String? packagingSize) async {
    if (state.hasValue) {
      final newState = state.value!.copyWith(packagingSize: packagingSize);
      await updateFilters(newState);
    }
  }

  void setTimeOfDay(DateTime time) {
    if (state.hasValue) {
      state = AsyncValue.data(state.value!.copyWith(timeOfDay: time));
    }
  }

  void setPortionSize(int size) {
    if (state.hasValue && size > 0 && size != state.value!.portionSize) {
      state = AsyncValue.data(state.value!.copyWith(portionSize: size));
    }
  }

  Future<SaveMealResult> saveMeal() async {
    if (!state.hasValue)
      return SaveMealResult(success: false, error: 'Invalid state');

    try {
      state =
          AsyncValue.data(state.value!.copyWith(isSaving: true, error: null));
      final mealModel = state.value!.toMealModel();

      if (initialMeal?.mealId != null) {
        final updatedMeal = await ref.read(mealsProvider.notifier).updateMeal(
              mealModel.copyWith(mealId: initialMeal!.mealId),
            );
        state = AsyncValue.data(state.value!.copyWith(isSaving: false));
        return SaveMealResult(success: true, mealId: updatedMeal.mealId);
      }

      final createdMeal =
          await ref.read(mealsProvider.notifier).createMeal(mealModel);
      state = AsyncValue.data(state.value!.copyWith(isSaving: false));
      return SaveMealResult(success: true, mealId: createdMeal.mealId);
    } catch (e) {
      state = AsyncValue.data(state.value!.copyWith(
        isSaving: false,
        error: 'Fehler beim Speichern: $e',
      ));
      return SaveMealResult(success: false, error: e.toString());
    }
  }
}
