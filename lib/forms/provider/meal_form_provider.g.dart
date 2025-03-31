// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealFormHash() => r'c524cad44e1cddb1dd909165b955a8124820cfdc';

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

abstract class _$MealForm
    extends BuildlessAutoDisposeAsyncNotifier<MealFormState> {
  late final MealModel? initialMeal;

  FutureOr<MealFormState> build(
    MealModel? initialMeal,
  );
}

/// See also [MealForm].
@ProviderFor(MealForm)
const mealFormProvider = MealFormFamily();

/// See also [MealForm].
class MealFormFamily extends Family<AsyncValue<MealFormState>> {
  /// See also [MealForm].
  const MealFormFamily();

  /// See also [MealForm].
  MealFormProvider call(
    MealModel? initialMeal,
  ) {
    return MealFormProvider(
      initialMeal,
    );
  }

  @override
  MealFormProvider getProviderOverride(
    covariant MealFormProvider provider,
  ) {
    return call(
      provider.initialMeal,
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
  String? get name => r'mealFormProvider';
}

/// See also [MealForm].
class MealFormProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MealForm, MealFormState> {
  /// See also [MealForm].
  MealFormProvider(
    MealModel? initialMeal,
  ) : this._internal(
          () => MealForm()..initialMeal = initialMeal,
          from: mealFormProvider,
          name: r'mealFormProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mealFormHash,
          dependencies: MealFormFamily._dependencies,
          allTransitiveDependencies: MealFormFamily._allTransitiveDependencies,
          initialMeal: initialMeal,
        );

  MealFormProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialMeal,
  }) : super.internal();

  final MealModel? initialMeal;

  @override
  FutureOr<MealFormState> runNotifierBuild(
    covariant MealForm notifier,
  ) {
    return notifier.build(
      initialMeal,
    );
  }

  @override
  Override overrideWith(MealForm Function() create) {
    return ProviderOverride(
      origin: this,
      override: MealFormProvider._internal(
        () => create()..initialMeal = initialMeal,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialMeal: initialMeal,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MealForm, MealFormState>
      createElement() {
    return _MealFormProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealFormProvider && other.initialMeal == initialMeal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialMeal.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MealFormRef on AutoDisposeAsyncNotifierProviderRef<MealFormState> {
  /// The parameter `initialMeal` of this provider.
  MealModel? get initialMeal;
}

class _MealFormProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MealForm, MealFormState>
    with MealFormRef {
  _MealFormProviderElement(super.provider);

  @override
  MealModel? get initialMeal => (origin as MealFormProvider).initialMeal;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
