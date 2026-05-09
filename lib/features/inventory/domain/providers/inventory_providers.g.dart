// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unitRepositoryHash() => r'0aecd36556eabdb355075aba8b3bd1b1e8a9b651';

/// See also [unitRepository].
@ProviderFor(unitRepository)
final unitRepositoryProvider = AutoDisposeProvider<UnitRepository>.internal(
  unitRepository,
  name: r'unitRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unitRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnitRepositoryRef = AutoDisposeProviderRef<UnitRepository>;
String _$categoryRepositoryHash() =>
    r'436c3b40b96075f5e514840fbd2eebcd7f908887';

/// See also [categoryRepository].
@ProviderFor(categoryRepository)
final categoryRepositoryProvider =
    AutoDisposeProvider<CategoryRepository>.internal(
      categoryRepository,
      name: r'categoryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryRepositoryRef = AutoDisposeProviderRef<CategoryRepository>;
String _$shopUnitsHash() => r'881a3d8be21776ccb2cdd9f92a43ffb816565360';

/// See also [shopUnits].
@ProviderFor(shopUnits)
final shopUnitsProvider = AutoDisposeStreamProvider<List<Unit>>.internal(
  shopUnits,
  name: r'shopUnitsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shopUnitsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopUnitsRef = AutoDisposeStreamProviderRef<List<Unit>>;
String _$shopCategoriesHash() => r'b66682516195488277502d6f713f93425560abc4';

/// See also [shopCategories].
@ProviderFor(shopCategories)
final shopCategoriesProvider =
    AutoDisposeStreamProvider<List<Category>>.internal(
      shopCategories,
      name: r'shopCategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shopCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopCategoriesRef = AutoDisposeStreamProviderRef<List<Category>>;
String _$subCategoriesHash() => r'a15143004d39b5f820aea6a703db4c5e433f918b';

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

/// See also [subCategories].
@ProviderFor(subCategories)
const subCategoriesProvider = SubCategoriesFamily();

/// See also [subCategories].
class SubCategoriesFamily extends Family<AsyncValue<List<SubCategory>>> {
  /// See also [subCategories].
  const SubCategoriesFamily();

  /// See also [subCategories].
  SubCategoriesProvider call(int categoryId) {
    return SubCategoriesProvider(categoryId);
  }

  @override
  SubCategoriesProvider getProviderOverride(
    covariant SubCategoriesProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subCategoriesProvider';
}

/// See also [subCategories].
class SubCategoriesProvider
    extends AutoDisposeStreamProvider<List<SubCategory>> {
  /// See also [subCategories].
  SubCategoriesProvider(int categoryId)
    : this._internal(
        (ref) => subCategories(ref as SubCategoriesRef, categoryId),
        from: subCategoriesProvider,
        name: r'subCategoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subCategoriesHash,
        dependencies: SubCategoriesFamily._dependencies,
        allTransitiveDependencies:
            SubCategoriesFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  SubCategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  Override overrideWith(
    Stream<List<SubCategory>> Function(SubCategoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubCategoriesProvider._internal(
        (ref) => create(ref as SubCategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<SubCategory>> createElement() {
    return _SubCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubCategoriesProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubCategoriesRef on AutoDisposeStreamProviderRef<List<SubCategory>> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _SubCategoriesProviderElement
    extends AutoDisposeStreamProviderElement<List<SubCategory>>
    with SubCategoriesRef {
  _SubCategoriesProviderElement(super.provider);

  @override
  int get categoryId => (origin as SubCategoriesProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
