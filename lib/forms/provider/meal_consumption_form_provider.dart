import 'package:cat_cuisine/models/meal_consumption_model.dart';
import 'package:cat_cuisine/models/provider/meal_consumption_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_consumption_form_provider.g.dart';

class SaveMealResult {
  final bool success;
  final String? mealId;
  final String? error;

  SaveMealResult({
    required this.success,
    this.mealId,
    this.error,
  });
}

class MealConsumptionFormState {
  final String mealId;
  final String catId;
  final int? portionSize;
  final int rating;
  final bool isSaving;
  final String? error;
  final TextEditingController portionController;

  MealConsumptionFormState({
    required this.mealId,
    required this.catId,
    this.portionSize,
    this.rating = 0,
    this.isSaving = false,
    this.error,
  }) : portionController =
            TextEditingController(text: portionSize?.toString() ?? '');

  MealConsumptionFormState copyWith({
    String? mealId,
    String? catId,
    int? portionSize,
    int? rating,
    bool? isSaving,
    String? error,
  }) {
    return MealConsumptionFormState(
      mealId: mealId ?? this.mealId,
      catId: catId ?? this.catId,
      portionSize: portionSize ?? this.portionSize,
      rating: rating ?? this.rating,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
    );
  }

  bool get isValid => portionSize != null && portionSize! > 0 && rating > 0;
}

@riverpod
class MealConsumptionForm extends _$MealConsumptionForm {
  @override
  MealConsumptionFormState build(String mealId, String? catId) {
    if (catId != null) {
      _loadExistingConsumption();
    }
    return MealConsumptionFormState(
      mealId: mealId,
      catId: catId ?? '', // Initialize with empty string if null
    );
  }

  void setCat(String catId) {
    state = state.copyWith(
      catId: catId,
      // Reset other values when cat changes
      portionSize: null,
      rating: 0,
    );
    _loadExistingConsumption();
  }

  Future<void> _loadExistingConsumption() async {
    final consumptions = await ref.read(mealConsumptionsProvider.future);
    final existing = consumptions.firstWhereOrNull(
        (c) => c.mealId == state.mealId && c.catId == state.catId);

    if (existing != null) {
      state = state.copyWith(
        portionSize: existing.portionSize,
        rating: existing.rating,
      );
      state.portionController.text = existing.portionSize.toString();
    }
  }

  void setPortionSize(int? size) {
    // Only update if the value actually changed
    if (size != null && size > 0 && size != state.portionSize) {
      state = state.copyWith(portionSize: size);
    }
  }

  void setRating(int rating) {
    if (rating >= 0 && rating <= 10) {
      state = state.copyWith(rating: rating);
    }
  }

  Future<bool> saveConsumption() async {
    if (!state.isValid) return false;

    try {
      state = state.copyWith(isSaving: true, error: null);

      final consumptions = await ref.read(mealConsumptionsProvider.future);
      final existing = consumptions.firstWhereOrNull(
          (c) => c.mealId == state.mealId && c.catId == state.catId);

      if (existing != null) {
        await ref.read(mealConsumptionsProvider.notifier).updateConsumption(
              existing.copyWith(
                portionSize: state.portionSize!,
                rating: state.rating,
              ),
            );
      } else {
        await ref.read(mealConsumptionsProvider.notifier).createConsumption(
              MealConsumptionModel(
                mealId: state.mealId,
                catId: state.catId,
                portionSize: state.portionSize!,
                rating: state.rating,
              ),
            );
      }

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Fehler beim Speichern: $e',
      );
      return false;
    }
  }

  Future<bool> deleteConsumption() async {
    try {
      state = state.copyWith(isSaving: true, error: null);

      final consumptions = await ref.read(mealConsumptionsProvider.future);
      final existing = consumptions.firstWhereOrNull(
          (c) => c.mealId == state.mealId && c.catId == state.catId);

      if (existing != null) {
        await ref
            .read(mealConsumptionsProvider.notifier)
            .deleteConsumption(existing.mealConsumptionId!);
      }

      state = MealConsumptionFormState(
        mealId: state.mealId,
        catId: state.catId,
      ); // Reset state while keeping IDs
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Fehler beim Löschen: $e',
      );
      return false;
    }
  }
}
