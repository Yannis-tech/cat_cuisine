import 'package:cat_cuisine/forms/provider/meal_consumption_form_provider.dart';
import 'package:cat_cuisine/models/meal_model.dart';
import 'package:cat_cuisine/provider/food_database_provider.dart';
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
  }) : portionController =
            TextEditingController(text: portionSize?.toString() ?? '');

  MealFormState copyWith(
      {String? brand,
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
      String? error}) {
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
        error: error ?? this.error);
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
  MealFormState build(MealModel? initialMeal) {
    return MealFormState(
      brand: initialMeal?.brandName,
      productLine: initialMeal?.productLine,
      sort: initialMeal?.sortName,
      packaging: initialMeal?.packaging,
      packagingSize: initialMeal?.packagingSize.toString(),
      timeOfDay: initialMeal?.timeOfDay,
      portionSize: initialMeal?.portionSize,
    );
  }

  Future<void> setBrand(String brand) async {
    final productLines =
        await ref.read(foodDataProvider.notifier).getProductLines(brand);

    state = state.copyWith(
      brand: brand,
      productLine: null,
      sort: null,
      packaging: null,
      packagingSize: null,
      availableProductLines: productLines,
      availableSorts: [],
      availablePackagings: [],
      availablePackagingSizes: [],
    );

    // Auto-select if only one option available
    if (productLines.length == 1) {
      await setProductLine(productLines[0]);
    }
  }

  Future<void> setProductLine(String productLine) async {
    if (state.brand == null) return;

    final sorts = await ref
        .read(foodDataProvider.notifier)
        .getSorts(state.brand!, productLine);

    state = state.copyWith(
      productLine: productLine,
      sort: null,
      packaging: null,
      packagingSize: null,
      availableSorts: sorts,
      availablePackagings: [],
      availablePackagingSizes: [],
    );

    // Auto-select if only one option available
    if (sorts.length == 1) {
      await setSort(sorts[0]);
    }
  }

  Future<void> setSort(String sort) async {
    if (state.brand == null || state.productLine == null) return;

    final packagings = await ref
        .read(foodDataProvider.notifier)
        .getPackagings(state.brand!, state.productLine!, sort);

    state = state.copyWith(
      sort: sort,
      packaging: null,
      packagingSize: null,
      availablePackagings: packagings,
      availablePackagingSizes: [],
    );

    // Auto-select if only one option available
    if (packagings.length == 1) {
      await setPackaging(packagings[0]);
    }
  }

  Future<void> setPackaging(String packaging) async {
    if (state.brand == null || state.productLine == null || state.sort == null)
      return;

    final sizes = await ref.read(foodDataProvider.notifier).getPackagingSizes(
        state.brand!, state.productLine!, state.sort!, packaging);

    state = state.copyWith(
      packaging: packaging,
      packagingSize: null,
      availablePackagingSizes: sizes,
    );

    // Auto-select if only one option available
    if (sizes.length == 1) {
      setPackagingSize(sizes[0]);
    }
  }

  void setPackagingSize(dynamic value) {
    if (value is String) {
      state = state.copyWith(packagingSize: value);
    } else if (value is int) {
      state = state.copyWith(packagingSize: '$value g');
    }
  }

  void setTimeOfDay(DateTime time) {
    state = state.copyWith(timeOfDay: time);
  }

  void setPortionSize(int size) {
    if (size > 0 && size != state.portionSize) {
      state = state.copyWith(portionSize: size);
    }
  }

  Future<SaveMealResult> saveMeal() async {
    try {
      state = state.copyWith(isSaving: true, error: null);

      final mealModel = state.toMealModel();
      String? newMealId;

      if (initialMeal?.mealId != null) {
        // Update existing meal
        final updatedMeal = await ref.read(mealsProvider.notifier).updateMeal(
              mealModel.copyWith(mealId: initialMeal!.mealId),
            );
        newMealId = updatedMeal.mealId;
      } else {
        // Create new meal
        final createdMeal =
            await ref.read(mealsProvider.notifier).createMeal(mealModel);
        newMealId = createdMeal.mealId;
      }

      state = state.copyWith(isSaving: false);
      return SaveMealResult(success: true, mealId: newMealId);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Fehler beim Speichern: $e',
      );
      return SaveMealResult(success: false, error: e.toString());
    }
  }
}
