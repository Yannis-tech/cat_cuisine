// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_consumption_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealConsumptionFormHash() =>
    r'b54a7fb99475b455db49dbaf05b9765ed03fe5be';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MealConsumptionForm
    extends BuildlessAutoDisposeNotifier<MealConsumptionFormState> {
  late final String mealId;
  late final String? catId;

  MealConsumptionFormState build(
    String mealId,
    String? catId,
  );
}

/// See also [MealConsumptionForm].
@ProviderFor(MealConsumptionForm)
const mealConsumptionFormProvider = MealConsumptionFormFamily();

/// See also [MealConsumptionForm].
class MealConsumptionFormFamily extends Family<MealConsumptionFormState> {
  /// See also [MealConsumptionForm].
  const MealConsumptionFormFamily();

  /// See also [MealConsumptionForm].
  MealConsumptionFormProvider call(
    String mealId,
    String? catId,
  ) {
    return MealConsumptionFormProvider(
      mealId,
      catId,
    );
  }

  @override
  MealConsumptionFormProvider getProviderOverride(
    covariant MealConsumptionFormProvider provider,
  ) {
    return call(
      provider.mealId,
      provider.catId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealConsumptionFormProvider';
}

/// See also [MealConsumptionForm].
class MealConsumptionFormProvider extends AutoDisposeNotifierProviderImpl<
    MealConsumptionForm, MealConsumptionFormState> {
  /// See also [MealConsumptionForm].
  MealConsumptionFormProvider(
    String mealId,
    String? catId,
  ) : this._internal(
          () => MealConsumptionForm()
            ..mealId = mealId
            ..catId = catId,
          from: mealConsumptionFormProvider,
          name: r'mealConsumptionFormProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mealConsumptionFormHash,
          dependencies: MealConsumptionFormFamily._dependencies,
          allTransitiveDependencies:
              MealConsumptionFormFamily._allTransitiveDependencies,
          mealId: mealId,
          catId: catId,
        );

  MealConsumptionFormProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealId,
    required this.catId,
  }) : super.internal();

  final String mealId;
  final String? catId;

  @override
  MealConsumptionFormState runNotifierBuild(
    covariant MealConsumptionForm notifier,
  ) {
    return notifier.build(
      mealId,
      catId,
    );
  }

  @override
  Override overrideWith(MealConsumptionForm Function() create) {
    return ProviderOverride(
      origin: this,
      override: MealConsumptionFormProvider._internal(
        () => create()
          ..mealId = mealId
          ..catId = catId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealId: mealId,
        catId: catId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MealConsumptionForm,
      MealConsumptionFormState> createElement() {
    return _MealConsumptionFormProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealConsumptionFormProvider &&
        other.mealId == mealId &&
        other.catId == catId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealId.hashCode);
    hash = _SystemHash.combine(hash, catId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MealConsumptionFormRef
    on AutoDisposeNotifierProviderRef<MealConsumptionFormState> {
  /// The parameter `mealId` of this provider.
  String get mealId;

  /// The parameter `catId` of this provider.
  String? get catId;
}

class _MealConsumptionFormProviderElement
    extends AutoDisposeNotifierProviderElement<MealConsumptionForm,
        MealConsumptionFormState> with MealConsumptionFormRef {
  _MealConsumptionFormProviderElement(super.provider);

  @override
  String get mealId => (origin as MealConsumptionFormProvider).mealId;
  @override
  String? get catId => (origin as MealConsumptionFormProvider).catId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
