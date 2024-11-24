import 'package:cat_cuisine/forms/provider/meal_consumption_form_provider.dart';
import 'package:cat_cuisine/models/provider/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditMealConsumptionScreen extends ConsumerWidget {
  final String mealId;

  const EditMealConsumptionScreen({
    super.key,
    required this.mealId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(catsProvider);

    return catsAsync.when(
      data: (cats) => DefaultTabController(
        length: cats.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Bewertungen'),
            bottom: TabBar(
              isScrollable: true,
              tabs: cats
                  .map((cat) => Tab(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  cat.avatarUrl?.startsWith('assets/') ?? false
                                      ? AssetImage(cat.avatarUrl!)
                                      : null,
                              child:
                                  cat.avatarUrl?.startsWith('assets/') ?? false
                                      ? null
                                      : const Icon(Icons.pets, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(cat.name ?? 'Unbekannt'),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: cats
                .map((cat) => _ConsumptionTab(
                      mealId: mealId,
                      catId: cat.catId,
                      catName: cat.name ?? 'Unbekannt',
                    ))
                .toList(),
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Fehler beim Laden')),
      ),
    );
  }
}

class _ConsumptionTab extends ConsumerWidget {
  final String mealId;
  final String catId;
  final String catName;

  const _ConsumptionTab({
    required this.mealId,
    required this.catId,
    required this.catName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(mealConsumptionFormProvider(mealId, catId));
    final notifier =
        ref.read(mealConsumptionFormProvider(mealId, catId).notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Portion (g)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            controller: formState.portionController,
            // Only update state when the field loses focus
            onEditingComplete: () {
              final size = int.tryParse(formState.portionController.text);
              if (size != null) notifier.setPortionSize(size);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Bewertung',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  index < formState.rating ? Icons.star : Icons.star_border,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => notifier.setRating(index + 1),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: formState.isValid && !formState.isSaving
                ? () => _saveConsumption(context, ref)
                : null,
            child: formState.isSaving
                ? const CircularProgressIndicator()
                : Text(formState.portionSize != null
                    ? 'Bewertung aktualisieren'
                    : 'Bewertung speichern'),
          ),
          if (formState.portionSize != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: formState.isSaving
                  ? null
                  : () => _deleteConsumption(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Bewertung löschen'),
            ),
          ],
          if (formState.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                formState.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _saveConsumption(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(mealConsumptionFormProvider(mealId, catId).notifier)
        .saveConsumption();

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bewertung gespeichert')),
      );
    }
  }

  Future<void> _deleteConsumption(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bewertung löschen'),
        content: const Text('Möchten Sie diese Bewertung wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(mealConsumptionFormProvider(mealId, catId).notifier)
          .deleteConsumption();

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bewertung gelöscht')),
        );
      }
    }
  }
}
