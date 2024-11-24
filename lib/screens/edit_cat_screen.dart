import 'package:cat_cuisine/models/cat_model.dart';
import 'package:cat_cuisine/forms/provider/cat_form_provider.dart';
import 'package:cat_cuisine/models/provider/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCatScreen extends ConsumerWidget {
  final CatModel? cat;

  const EditCatScreen({super.key, this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the form provider to get the current state of the form
    final catFormState = ref.watch(catFormProvider(cat));
    final catFormNotifier = ref.read(catFormProvider(cat).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(cat != null ? 'Daten ändern' : 'Wer soll hier einziehen?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: catFormState.name,
              onChanged: (value) => catFormNotifier.setName(value),
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Geburtstag'),
              subtitle: Text(
                catFormState.birthday?.toString().split(' ')[0] ??
                    'Bitte auswählen',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: catFormState.birthday ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  catFormNotifier.setBirthday(date);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: catFormState.avatarUrl,
              onChanged: (value) => catFormNotifier.setAvatarUrl(value),
              decoration: const InputDecoration(labelText: 'Avatar URL'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await catFormNotifier.saveCat();
                ref.invalidate(catsProvider);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                  cat != null ? 'Daten ändern' : 'Wer soll hier einziehen?'),
            ),
          ],
        ),
      ),
    );
  }
}
