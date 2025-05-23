import 'package:cat_cuisine/forms/provider/meal_consumption_form_provider.dart';
import 'package:cat_cuisine/models/cat_model.dart';
import 'package:cat_cuisine/models/provider/cat_provider.dart';
import 'package:cat_cuisine/models/provider/meal_consumption_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCatIdProvider = StateProvider.autoDispose<String?>((ref) => null);

class MealConsumptionForm extends ConsumerWidget {
  final String mealId;

  const MealConsumptionForm({
    super.key,
    required this.mealId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(catsProvider);
    final selectedCatId = ref.watch(selectedCatIdProvider);
    final formState =
        ref.watch(mealConsumptionFormProvider(mealId, selectedCatId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bewertung hinzufügen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            catsAsync.when(
              data: (cats) =>
                  _buildConsumptionForm(context, ref, cats, formState),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Fehler beim Laden der Katzen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionForm(
    BuildContext context,
    WidgetRef ref,
    List<CatModel> cats,
    MealConsumptionFormState formState,
  ) {
    final notifier = ref.read(
        mealConsumptionFormProvider(mealId, ref.read(selectedCatIdProvider))
            .notifier);

    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Katze',
            border: OutlineInputBorder(),
          ),
          value: formState.catId,
          items: cats
              .map((cat) => DropdownMenuItem(
                    value: cat.catId,
                    child: Text(cat.name ?? 'Unbenannte Katze'),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              ref.read(selectedCatIdProvider.notifier).state = value;
              notifier.setCat(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Portionsgröße (g)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          initialValue: formState.portionSize?.toString(),
          onChanged: (value) {
            final size = int.tryParse(value);
            if (size != null) notifier.setPortionSize(size);
          },
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bewertung: ${formState.rating}/10',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Slider(
              value: formState.rating.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: '${formState.rating}',
              onChanged: (double value) => notifier.setRating(value.round()),
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: formState.isValid && !formState.isSaving
              ? () => _saveConsumption(context, ref)
              : null,
          child: formState.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Bewertung speichern'),
        ),
        if (formState.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              formState.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }

  Future<void> _saveConsumption(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(
            mealConsumptionFormProvider(mealId, ref.read(selectedCatIdProvider))
                .notifier)
        .saveConsumption();

    if (!context.mounted) return;

    if (success) {
      ref.invalidate(mealConsumptionsForMealProvider(mealId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bewertung erfolgreich gespeichert'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
