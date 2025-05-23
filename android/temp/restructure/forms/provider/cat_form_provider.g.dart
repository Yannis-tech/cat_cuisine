// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$catFormHash() => r'35a273c7746c99dfa8d2af52d222b39fb35d011f';

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

abstract class _$CatForm extends BuildlessAutoDisposeNotifier<CatFormState> {
  late final InvalidType initialCat;

  CatFormState build(
    InvalidType initialCat,
  );
}

/// See also [CatForm].
@ProviderFor(CatForm)
const catFormProvider = CatFormFamily();

/// See also [CatForm].
class CatFormFamily extends Family<CatFormState> {
  /// See also [CatForm].
  const CatFormFamily();

  /// See also [CatForm].
  CatFormProvider call(
    InvalidType initialCat,
  ) {
    return CatFormProvider(
      initialCat,
    );
  }

  @override
  CatFormProvider getProviderOverride(
    covariant CatFormProvider provider,
  ) {
    return call(
      provider.initialCat,
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
  String? get name => r'catFormProvider';
}

/// See also [CatForm].
class CatFormProvider
    extends AutoDisposeNotifierProviderImpl<CatForm, CatFormState> {
  /// See also [CatForm].
  CatFormProvider(
    InvalidType initialCat,
  ) : this._internal(
          () => CatForm()..initialCat = initialCat,
          from: catFormProvider,
          name: r'catFormProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$catFormHash,
          dependencies: CatFormFamily._dependencies,
          allTransitiveDependencies: CatFormFamily._allTransitiveDependencies,
          initialCat: initialCat,
        );

  CatFormProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialCat,
  }) : super.internal();

  final InvalidType initialCat;

  @override
  CatFormState runNotifierBuild(
    covariant CatForm notifier,
  ) {
    return notifier.build(
      initialCat,
    );
  }

  @override
  Override overrideWith(CatForm Function() create) {
    return ProviderOverride(
      origin: this,
      override: CatFormProvider._internal(
        () => create()..initialCat = initialCat,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialCat: initialCat,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CatForm, CatFormState> createElement() {
    return _CatFormProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CatFormProvider && other.initialCat == initialCat;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialCat.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CatFormRef on AutoDisposeNotifierProviderRef<CatFormState> {
  /// The parameter `initialCat` of this provider.
  InvalidType get initialCat;
}

class _CatFormProviderElement
    extends AutoDisposeNotifierProviderElement<CatForm, CatFormState>
    with CatFormRef {
  _CatFormProviderElement(super.provider);

  @override
  InvalidType get initialCat => (origin as CatFormProvider).initialCat;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
