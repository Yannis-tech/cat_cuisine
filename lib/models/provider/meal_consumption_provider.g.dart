// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_consumption_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealConsumptionsForMealHash() =>
    r'e3ed0de6998e6f055edbc2dd5e3adc5ee4ac253e';

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

/// See also [mealConsumptionsForMeal].
@ProviderFor(mealConsumptionsForMeal)
const mealConsumptionsForMealProvider = MealConsumptionsForMealFamily();

/// See also [mealConsumptionsForMeal].
class MealConsumptionsForMealFamily
    extends Family<AsyncValue<List<MealConsumptionModel>>> {
  /// See also [mealConsumptionsForMeal].
  const MealConsumptionsForMealFamily();

  /// See also [mealConsumptionsForMeal].
  MealConsumptionsForMealProvider call(
    String? mealId,
  ) {
    return MealConsumptionsForMealProvider(
      mealId,
    );
  }

  @override
  MealConsumptionsForMealProvider getProviderOverride(
    covariant MealConsumptionsForMealProvider provider,
  ) {
    return call(
      provider.mealId,
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
  String? get name => r'mealConsumptionsForMealProvider';
}

/// See also [mealConsumptionsForMeal].
class MealConsumptionsForMealProvider
    extends AutoDisposeFutureProvider<List<MealConsumptionModel>> {
  /// See also [mealConsumptionsForMeal].
  MealConsumptionsForMealProvider(
    String? mealId,
  ) : this._internal(
          (ref) => mealConsumptionsForMeal(
            ref as MealConsumptionsForMealRef,
            mealId,
          ),
          from: mealConsumptionsForMealProvider,
          name: r'mealConsumptionsForMealProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mealConsumptionsForMealHash,
          dependencies: MealConsumptionsForMealFamily._dependencies,
          allTransitiveDependencies:
              MealConsumptionsForMealFamily._allTransitiveDependencies,
          mealId: mealId,
        );

  MealConsumptionsForMealProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealId,
  }) : super.internal();

  final String? mealId;

  @override
  Override overrideWith(
    FutureOr<List<MealConsumptionModel>> Function(
            MealConsumptionsForMealRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealConsumptionsForMealProvider._internal(
        (ref) => create(ref as MealConsumptionsForMealRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealId: mealId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MealConsumptionModel>> createElement() {
    return _MealConsumptionsForMealProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealConsumptionsForMealProvider && other.mealId == mealId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MealConsumptionsForMealRef
    on AutoDisposeFutureProviderRef<List<MealConsumptionModel>> {
  /// The parameter `mealId` of this provider.
  String? get mealId;
}

class _MealConsumptionsForMealProviderElement
    extends AutoDisposeFutureProviderElement<List<MealConsumptionModel>>
    with MealConsumptionsForMealRef {
  _MealConsumptionsForMealProviderElement(super.provider);

  @override
  String? get mealId => (origin as MealConsumptionsForMealProvider).mealId;
}

String _$mealConsumptionsHash() => r'44f88f4b2e9c8875dbd3efe8b6950fd05c292faa';

/// See also [MealConsumptions].
@ProviderFor(MealConsumptions)
final mealConsumptionsProvider = AutoDisposeAsyncNotifierProvider<
    MealConsumptions, List<MealConsumptionModel>>.internal(
  MealConsumptions.new,
  name: r'mealConsumptionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealConsumptionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MealConsumptions
    = AutoDisposeAsyncNotifier<List<MealConsumptionModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
