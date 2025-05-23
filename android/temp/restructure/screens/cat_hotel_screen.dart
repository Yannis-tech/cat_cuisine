import 'package:cat_cuisine/models/cat_model.dart';
import 'package:cat_cuisine/models/provider/cat_provider.dart';
import 'package:cat_cuisine/screens/edit_cat_screen.dart';
import 'package:cat_cuisine/utils/cat_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatHotelScreen extends ConsumerWidget {
  const CatHotelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsyncValue = ref.watch(catsProvider);

    return Scaffold(
      body: catsAsyncValue.when(
        data: (cats) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: cats.length,
          itemBuilder: (context, index) {
            final cat = cats[index];
            return GestureDetector(
              onTap: () => _navigateToEditCat(context, cat),
              child: Dismissible(
                key: Key(cat.catId),
                direction: DismissDirection.endToStart,
                background: _buildSwipeActionRight(),
                confirmDismiss: (direction) async {
                  return await _showDeleteConfirmationDialog(context);
                },
                onDismissed: (direction) async {
                  await ref.read(catsProvider.notifier).deleteCat(cat.catId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${cat.name} deleted')),
                    );
                  }
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 4,
                        child: cat.avatarUrl != null &&
                                cat.avatarUrl!.isNotEmpty
                            ? Image.network(
                                cat.avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildCatImage(cat.avatarUrl ?? '');
                                },
                              )
                            : _buildCatImage(cat.avatarUrl ?? ''),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cat.name ?? 'Unnamed Cat',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${cat.age ?? '???'} Jahre alt',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addCat',
        onPressed: () => _navigateToAddCat(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCatImage(String avatarUrl) {
    return avatarUrl.startsWith('assets/')
        ? Image.asset(
            avatarUrl,
            fit: BoxFit.cover,
          )
        : Image.network(
            avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(CatImageProvider.getRandomCatImage());
            },
          );
  }

  // Swipe action widget for deleting
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

  // Confirmation dialog for delete action
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Cat'),
          content: const Text('Are you sure you want to delete this cat?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Navigate to add cat screen
  void _navigateToAddCat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditCatScreen()),
    );
  }

  // Navigate to edit cat screen
  void _navigateToEditCat(BuildContext context, CatModel cat) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditCatScreen(cat: cat)),
    );
  }
}
