import 'package:cat_cuisine/models/provider/cat_provider.dart';
import 'package:cat_cuisine/models/provider/meal_consumption_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_model.dart';
import '../models/cat_model.dart';
import '../utils/cat_image_provider.dart';

class MealConsumptionList extends ConsumerWidget {
  final MealModel meal;

  const MealConsumptionList({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (meal.mealId == null) {
      return const SizedBox.shrink();
    }

    final consumptionsAsync =
        ref.watch(mealConsumptionsForMealProvider(meal.mealId!));
    final catsAsync = ref.watch(catsProvider);

    return consumptionsAsync.when(
      data: (consumptions) => catsAsync.when(
        data: (cats) {
          if (consumptions.isEmpty) {
            return _buildEmptyConsumption(context);
          }

          final consumptionViews = consumptions.map((consumption) {
            final cat = cats.firstWhere(
              (c) => c.catId == consumption.catId,
              orElse: () => CatModel(
                catId: '0',
                name: 'fremder Streuner',
              ),
            );
            return _buildCatConsumption(
              context,
              cat,
              consumption.portionSize,
              consumption.rating,
            );
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: consumptionViews,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Text('Fehler beim Rufen der Katzen'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text('Fehler beim Laden der Bewertungen'),
    );
  }

  Widget _buildCatConsumption(
    BuildContext context,
    CatModel cat,
    int portion,
    int rating,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          ClipOval(
            child: cat.avatarUrl?.startsWith('assets/') ?? false
                ? Image.asset(
                    cat.avatarUrl!,
                    width: 16,
                    height: 16,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    cat.avatarUrl ?? '',
                    width: 16,
                    height: 16,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      CatImageProvider.getRandomCatImage(),
                      width: 16,
                      height: 16,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${cat.name} (${portion}g)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          _buildRatingStars(context, rating),
        ],
      ),
    );
  }

  Widget _buildEmptyConsumption(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.pets, size: 16),
          SizedBox(width: 8),
          Text('Noch keine Bewertung'),
        ],
      ),
    );
  }

  Widget _buildRatingStars(BuildContext context, int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        );
      }),
    );
  }
}
