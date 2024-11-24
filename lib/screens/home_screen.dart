import 'package:cat_cuisine/models/cat_model.dart';
import 'package:cat_cuisine/models/meal_model.dart';
import 'package:cat_cuisine/models/provider/cat_provider.dart';
import 'package:cat_cuisine/models/provider/meal_consumption_provider.dart';
import 'package:cat_cuisine/models/provider/meal_provider.dart';
import 'package:cat_cuisine/screens/edit_meal_consumption_screen.dart';
import 'package:cat_cuisine/screens/edit_meal_screen.dart';
import 'package:cat_cuisine/utils/cat_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ConsumptionInfo {
  final String catName;
  final int portion;
  final int rating;

  _ConsumptionInfo({
    required this.catName,
    required this.portion,
    required this.rating,
  });
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Widget _buildSwipeActionRight() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Future<void> _showMealOptions(BuildContext context, MealModel meal) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Mahlzeit bearbeiten'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('edit'),
            child: const Text('Mahlzeit bearbeiten'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('consumption'),
            child: const Text('Bewertungen verwalten'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (choice == 'edit') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditMealScreen(meal: meal)),
      );
    } else if (choice == 'consumption') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditMealConsumptionScreen(mealId: meal.mealId!),
        ),
      );
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mahlzeit löschen'),
          content: const Text('Soll die Mahlzeit wirklich gelöscht werden?'),
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
        );
      },
    );
  }

  void _navigateToAddMeal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditMealScreen()),
    );
  }

  void _navigateToEditMeal(BuildContext context, MealModel meal) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditMealScreen(meal: meal)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsyncValue = ref.watch(mealsProvider);

    return Scaffold(
      body: mealsAsyncValue.when(
        data: (meals) {
          final recentMeals = meals.where((meal) {
            final daysAgo = DateTime.now().difference(meal.createdAt).inDays;
            return daysAgo <= 7;
          }).toList();

          recentMeals.sort((a, b) => b.timeOfDay.compareTo(a.timeOfDay));

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: recentMeals.length,
            itemBuilder: (context, index) {
              final meal = recentMeals[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildMealCard(context, meal, ref),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addMeal',
        onPressed: () => _navigateToAddMeal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, MealModel meal, WidgetRef ref) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showMealOptions(context, meal),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeIndicator(context, meal.timeOfDay),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${meal.brandName} - ${meal.sortName}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        _buildPackagingInfo(context, meal),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildConsumptionInfo(context, meal, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeIndicator(BuildContext context, DateTime timeOfDay) {
    // Get hour from timestamp
    final hour = timeOfDay.hour;

    // Determine time of day and icon
    String period;
    IconData icon;
    if (hour >= 5 && hour < 11) {
      period = 'Morgens';
      icon = Icons.wb_sunny_outlined;
    } else if (hour >= 11 && hour < 14) {
      period = 'Mittags';
      icon = Icons.wb_sunny;
    } else if (hour >= 14 && hour < 17) {
      period = 'Nachmittags';
      icon = Icons.wb_sunny_outlined;
    } else if (hour >= 17 && hour < 23) {
      period = 'Abends';
      icon = Icons.nights_stay_outlined;
    } else {
      period = 'Nachts';
      icon = Icons.bedtime;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            period,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          Text(
            '${timeOfDay.day}.${timeOfDay.month}.${timeOfDay.year}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagingInfo(BuildContext context, MealModel meal) {
    IconData icon;
    switch (meal.packaging.toLowerCase()) {
      case 'can':
        icon = Icons.radio_button_checked;
        break;
      case 'pouch':
        icon = Icons.inventory_2_outlined;
        break;
      default:
        icon = Icons.inventory;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 4),
        Text(
          '${meal.packagingSize}g',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        const Icon(Icons.food_bank_outlined, size: 16),
        const SizedBox(width: 4),
        Text(
          '${meal.portionSize}g',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCatImage(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return Image.asset(
        CatImageProvider.getRandomCatImage(),
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      );
    }

    return avatarUrl.startsWith('assets/')
        ? Image.asset(
            avatarUrl,
            width: 16,
            height: 16,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              CatImageProvider.getRandomCatImage(),
              width: 16,
              height: 16,
              fit: BoxFit.cover,
            ),
          )
        : Image.network(
            avatarUrl,
            width: 16,
            height: 16,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              CatImageProvider.getRandomCatImage(),
              width: 16,
              height: 16,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _buildConsumptionInfo(
      BuildContext context, MealModel meal, WidgetRef ref) {
    if (meal.mealId == null) {
      return _buildEmptyConsumption(context);
    }

    Widget buildCatConsumption(_ConsumptionInfo info, CatModel cat) {
      // Add CatModel parameter
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
                '${info.catName} (${info.portion}g)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            _buildRatingStars(context, info.rating),
          ],
        ),
      );
    }

    final consumptionsAsync =
        ref.watch(mealConsumptionsForMealProvider(meal.mealId!));

    return consumptionsAsync.when(
      data: (consumptions) {
        if (consumptions.isEmpty) {
          return _buildEmptyConsumption(context);
        }

        final catsAsync = ref.watch(catsProvider);

        return catsAsync.when(
          data: (cats) {
            final consumptionViews = consumptions.map((consumption) {
              final cat = cats.firstWhere(
                (c) => c.catId == consumption.catId,
                orElse: () => CatModel(
                  catId: '0',
                  name: 'fremder Streuner',
                ),
              );
              final info = _ConsumptionInfo(
                catName: cat.name ?? 'fremder Streuner',
                portion: consumption.portionSize,
                rating: consumption.rating,
              );
              return buildCatConsumption(info, cat); // Pass both info and cat
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: consumptionViews,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Text('Fehler beim Rufen der Katzen'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text('Fehler beim Laden der Bewertungen'),
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
