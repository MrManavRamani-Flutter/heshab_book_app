// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncRepositoryHash() => r'db739f5af3ef3316bdfc5f4e95660e65c230753a';

/// See also [syncRepository].
@ProviderFor(syncRepository)
final syncRepositoryProvider = AutoDisposeProvider<SyncRepository>.internal(
  syncRepository,
  name: r'syncRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncRepositoryRef = AutoDisposeProviderRef<SyncRepository>;
String _$pendingSyncCountHash() => r'ec1656bc646d16a432d19156ff115a23d5f9e455';

/// See also [pendingSyncCount].
@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = AutoDisposeStreamProvider<int>.internal(
  pendingSyncCount,
  name: r'pendingSyncCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingSyncCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingSyncCountRef = AutoDisposeStreamProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
