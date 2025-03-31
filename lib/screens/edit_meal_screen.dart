import 'package:cat_cuisine/forms/meal_consumption_form.dart';
import 'package:cat_cuisine/models/meal_model.dart';
import 'package:cat_cuisine/screens/edit_meal_consumption_screen.dart';
import 'package:cat_cuisine/utils/meal_consumption_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../forms/provider/meal_form_provider.dart';
import '../provider/food_database_provider.dart';

class EditMealScreen extends ConsumerWidget {
  final MealModel? meal;
  const EditMealScreen({super.key, this.meal});

  bool _hasChanges(AsyncValue<MealFormState> formState) {
    if (!formState.hasValue) return false;
    final state = formState.value!;
    return state.brand != null ||
        state.productLine != null ||
        state.sort != null ||
        state.packaging != null ||
        state.packagingSize != null ||
        state.portionSize != null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formStateAsync = ref.watch(mealFormProvider(meal));
    final brands = ref.watch(foodDataProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (!_hasChanges(formStateAsync)) {
          Navigator.of(context).pop();
          return;
        }

        final bool shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Änderungen verwerfen?'),
                content:
                    const Text('Die vorgenommenen Änderungen gehen verloren.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Abbrechen'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Verwerfen'),
                  ),
                ],
              ),
            ) ??
            false;

        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              meal != null ? 'Mahlzeit bearbeiten' : 'Mahlzeit hinzufügen'),
        ),
        body: formStateAsync.when(
          data: (formState) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDateTimePicker(context, ref, formState),
                const SizedBox(height: 16),
                brands.when(
                  data: (brandList) =>
                      _buildBrandDropdown(context, ref, formState, brandList),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Fehler beim Laden der Daten'),
                ),
                if (formState.brand != null) ...[
                  const SizedBox(height: 16),
                  _buildProductLineDropdown(context, ref, formState),
                ],
                if (formState.productLine != null) ...[
                  const SizedBox(height: 16),
                  _buildSortDropdown(context, ref, formState),
                ],
                if (formState.sort != null) ...[
                  const SizedBox(height: 16),
                  _buildPackagingDropdown(context, ref, formState),
                ],
                if (formState.packaging != null) ...[
                  const SizedBox(height: 16),
                  _buildPackagingSizeDropdown(context, ref, formState),
                ],
                const SizedBox(height: 24),
                _buildPortionSizeField(context, ref, formState),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: formState.isSaving || !_isFormValid(formStateAsync)
                      ? null
                      : () => _saveMeal(context, ref),
                  child: formState.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(meal != null
                          ? 'Mahlzeit bearbeiten'
                          : 'Mahlzeit hinzufügen'),
                ),
                if (meal?.mealId != null) ...[
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text('Bewertungen',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _buildConsumptionList(context, ref, meal),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showAddConsumptionDialog(context, meal!.mealId!),
                    icon: const Icon(Icons.add),
                    label: const Text('Bewertung hinzufügen'),
                  ),
                ],
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildConsumptionList(
      BuildContext context, WidgetRef ref, MealModel? meal) {
    if (meal == null || meal.mealId == null) {
      return const SizedBox.shrink();
    }

    return MealConsumptionList(meal: meal);
  }

  void _showAddConsumptionDialog(BuildContext context, String mealId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MealConsumptionForm(mealId: mealId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(
      BuildContext context, WidgetRef ref, MealFormState state) {
    String formatDateTime(DateTime? dateTime) {
      if (dateTime == null) return 'Datum und Zeit auswählen';
      return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: state.timeOfDay ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay.fromDateTime(state.timeOfDay ?? DateTime.now()),
          );

          if (time != null) {
            final dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            ref.read(mealFormProvider(meal).notifier).setTimeOfDay(dateTime);
          }
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fütterungszeit',
          border: OutlineInputBorder(),
        ),
        child: Text(
          formatDateTime(state.timeOfDay),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildBrandDropdown(BuildContext context, WidgetRef ref,
      MealFormState state, List<String> brands) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Marke',
        border: OutlineInputBorder(),
      ),
      value: state.brand,
      items: brands
          .map((brand) => DropdownMenuItem(
                value: brand,
                child: Text(brand),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(mealFormProvider(meal).notifier).setBrand(value);
        }
      },
    );
  }

  Widget _buildProductLineDropdown(
      BuildContext context, WidgetRef ref, MealFormState state) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Produktlinie',
        border: OutlineInputBorder(),
      ),
      value: state.productLine,
      items: state.availableProductLines
          .map((line) => DropdownMenuItem(
                value: line,
                child: Text(line),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(mealFormProvider(meal).notifier).setProductLine(value);
        }
      },
    );
  }

  Widget _buildPortionSizeField(
      BuildContext context, WidgetRef ref, MealFormState state) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Fütterungsmenge (g)',
        border: const OutlineInputBorder(),
        helperText:
            'Empfohlene Menge: ${state.packagingSize != null ? '${(int.tryParse(state.packagingSize!) ?? 0) / 2}g' : '-'}',
        errorText: state.portionSize != null && state.portionSize! <= 0
            ? 'Bitte geben Sie eine gültige Menge ein'
            : null,
      ),
      keyboardType: TextInputType.number,
      controller: state.portionController,
      onEditingComplete: () {
        final size = int.tryParse(state.portionController.text);
        if (size != null) {
          ref.read(mealFormProvider(meal).notifier).setPortionSize(size);
        }
        FocusScope.of(context).unfocus(); // Optional: hide keyboard when done
      },
      // Add this to ensure value is saved when focus is lost
      onFieldSubmitted: (value) {
        final size = int.tryParse(value);
        if (size != null) {
          ref.read(mealFormProvider(meal).notifier).setPortionSize(size);
        }
      },
    );
  }

  Widget _buildSortDropdown(
      BuildContext context, WidgetRef ref, MealFormState state) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Sorte',
        border: OutlineInputBorder(),
      ),
      value: state.sort,
      items: state.availableSorts
          .map((sort) => DropdownMenuItem(
                value: sort,
                child: Text(sort),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(mealFormProvider(meal).notifier).setSort(value);
        }
      },
    );
  }

  Widget _buildPackagingDropdown(
      BuildContext context, WidgetRef ref, MealFormState state) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Verpackungsart',
        border: OutlineInputBorder(),
      ),
      value: state.packaging,
      items: state.availablePackagings
          .map((packaging) => DropdownMenuItem(
                value: packaging,
                child: Text(packaging),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(mealFormProvider(meal).notifier).setPackaging(value);
        }
      },
    );
  }

  Widget _buildPackagingSizeDropdown(
      BuildContext context, WidgetRef ref, MealFormState state) {
    final packagingSizes = <int>{};

    // Parse available sizes
    for (final size in state.availablePackagingSizes) {
      final sizes = size
          .split(',')
          .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')))
          .whereType<int>();
      packagingSizes.addAll(sizes);
    }

    final numericSizes = packagingSizes.toList()..sort();

    // Parse selected size
    int? selectedSize;
    if (state.packagingSize != null) {
      selectedSize =
          int.tryParse(state.packagingSize!.replaceAll(RegExp(r'[^0-9]'), ''));
      // Validate selected size exists in available sizes
      if (selectedSize != null && !numericSizes.contains(selectedSize)) {
        selectedSize = null;
      }
    }

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Packungsgröße (g)',
        border: OutlineInputBorder(),
      ),
      value: selectedSize,
      items: numericSizes
          .map((size) => DropdownMenuItem(
                value: size,
                child: Text('$size g'),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          // Ensure consistent string format
          ref
              .read(mealFormProvider(meal).notifier)
              .setPackagingSize(value.toString());
        }
      },
    );
  }

  bool _isFormValid(AsyncValue<MealFormState> state) {
    if (!state.hasValue) return false;
    final formState = state.value!;
    return formState.brand != null &&
        formState.productLine != null &&
        formState.sort != null &&
        formState.packaging != null &&
        formState.packagingSize != null &&
        formState.timeOfDay != null &&
        formState.portionSize != null;
  }

  void _saveMeal(BuildContext context, WidgetRef ref) async {
    final saveMealResult =
        await ref.read(mealFormProvider(meal).notifier).saveMeal();

    if (!context.mounted) return;

    if (saveMealResult.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mahlzeit erfolgreich gespeichert')),
      );

      if (meal == null && saveMealResult.mealId != null) {
        final shouldAddConsumption = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Bewertung hinzufügen?'),
            content: const Text(
                'Möchten Sie jetzt eine Bewertung für diese Mahlzeit hinzufügen?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Später'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Jetzt bewerten'),
              ),
            ],
          ),
        );

        if (shouldAddConsumption == true && context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  EditMealConsumptionScreen(mealId: saveMealResult.mealId!),
            ),
          );
          return;
        }
      }
      Navigator.of(context).pop();
    } else {
      final formState = ref.read(mealFormProvider(meal));
      if (formState.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(formState.value!.error ??
                'Ein unbekannter Fehler ist aufgetreten'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
