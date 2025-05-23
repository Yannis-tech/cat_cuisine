import 'package:cat_cuisine/models/cat_model.dart';
import 'package:cat_cuisine/models/provider/cat_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cat_form_provider.g.dart';

class CatFormState {
  final String? catId;
  final String? name;
  final DateTime? birthday;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CatFormState({
    this.catId,
    this.name,
    this.birthday,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  CatFormState copyWith({
    String? catId,
    String? name,
    DateTime? birthday,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CatFormState(
      catId: catId ?? this.catId,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CatModel toCatModel() {
    return CatModel(
      catId: catId ?? '0',
      name: name,
      birthday: birthday,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@riverpod
class CatForm extends _$CatForm {
  @override
  CatFormState build(CatModel? initialCat) {
    return CatFormState(
      catId: initialCat?.catId,
      name: initialCat?.name,
      birthday: initialCat?.birthday,
      avatarUrl: initialCat?.avatarUrl,
      createdAt: initialCat?.createdAt,
      updatedAt: initialCat?.updatedAt,
    );
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setBirthday(DateTime birthday) {
    state = state.copyWith(birthday: birthday);
  }

  void setAvatarUrl(String avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }

  Future<void> saveCat() async {
    final cats = ref.read(catsProvider.notifier);
    final cat = state.toCatModel();

    if (initialCat != null) {
      await cats.updateCat(cat);
    } else {
      await cats.createCat(cat);
    }
  }
}
