// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$catsTableHash() => r'b553e57804e33c8b922e1ecdea2992990206a974';

/// See also [catsTable].
@ProviderFor(catsTable)
final catsTableProvider = AutoDisposeProvider<CatsSupabaseTable>.internal(
  catsTable,
  name: r'catsTableProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$catsTableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatsTableRef = AutoDisposeProviderRef<CatsSupabaseTable>;
String _$supabaseRepositoryHash() =>
    r'48d3485f18ac4e6116e7917b7dde904515d16d43';

/// See also [supabaseRepository].
@ProviderFor(supabaseRepository)
final supabaseRepositoryProvider =
    AutoDisposeProvider<SupabaseDatabaseRepository>.internal(
  supabaseRepository,
  name: r'supabaseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseRepositoryRef
    = AutoDisposeProviderRef<SupabaseDatabaseRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
