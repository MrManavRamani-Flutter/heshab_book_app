// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseRepositoryHash() => r'44a0d57b5c61c7a5bce653453554ba6faab44f4b';

/// See also [expenseRepository].
@ProviderFor(expenseRepository)
final expenseRepositoryProvider =
    AutoDisposeProvider<ExpenseRepository>.internal(
      expenseRepository,
      name: r'expenseRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expenseRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRepositoryRef = AutoDisposeProviderRef<ExpenseRepository>;
String _$shopExpensesHash() => r'92cd58bd8867591ad74b79884bd3f7d6a0858251';

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

/// See also [shopExpenses].
@ProviderFor(shopExpenses)
const shopExpensesProvider = ShopExpensesFamily();

/// See also [shopExpenses].
class ShopExpensesFamily extends Family<AsyncValue<List<Expense>>> {
  /// See also [shopExpenses].
  const ShopExpensesFamily();

  /// See also [shopExpenses].
  ShopExpensesProvider call({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  }) {
    return ShopExpensesProvider(
      startDate: startDate,
      endDate: endDate,
      category: category,
    );
  }

  @override
  ShopExpensesProvider getProviderOverride(
    covariant ShopExpensesProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      category: provider.category,
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
  String? get name => r'shopExpensesProvider';
}

/// See also [shopExpenses].
class ShopExpensesProvider extends AutoDisposeStreamProvider<List<Expense>> {
  /// See also [shopExpenses].
  ShopExpensesProvider({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  }) : this._internal(
         (ref) => shopExpenses(
           ref as ShopExpensesRef,
           startDate: startDate,
           endDate: endDate,
           category: category,
         ),
         from: shopExpensesProvider,
         name: r'shopExpensesProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$shopExpensesHash,
         dependencies: ShopExpensesFamily._dependencies,
         allTransitiveDependencies:
             ShopExpensesFamily._allTransitiveDependencies,
         startDate: startDate,
         endDate: endDate,
         category: category,
       );

  ShopExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.category,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;
  final String? category;

  @override
  Override overrideWith(
    Stream<List<Expense>> Function(ShopExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopExpensesProvider._internal(
        (ref) => create(ref as ShopExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Expense>> createElement() {
    return _ShopExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopExpensesProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopExpensesRef on AutoDisposeStreamProviderRef<List<Expense>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `category` of this provider.
  String? get category;
}

class _ShopExpensesProviderElement
    extends AutoDisposeStreamProviderElement<List<Expense>>
    with ShopExpensesRef {
  _ShopExpensesProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as ShopExpensesProvider).startDate;
  @override
  DateTime? get endDate => (origin as ShopExpensesProvider).endDate;
  @override
  String? get category => (origin as ShopExpensesProvider).category;
}

String _$totalExpensesHash() => r'3a01ee35dc66f24700bce56cd087cde30d1f7378';

/// See also [totalExpenses].
@ProviderFor(totalExpenses)
const totalExpensesProvider = TotalExpensesFamily();

/// See also [totalExpenses].
class TotalExpensesFamily extends Family<double> {
  /// See also [totalExpenses].
  const TotalExpensesFamily();

  /// See also [totalExpenses].
  TotalExpensesProvider call({DateTime? startDate, DateTime? endDate}) {
    return TotalExpensesProvider(startDate: startDate, endDate: endDate);
  }

  @override
  TotalExpensesProvider getProviderOverride(
    covariant TotalExpensesProvider provider,
  ) {
    return call(startDate: provider.startDate, endDate: provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'totalExpensesProvider';
}

/// See also [totalExpenses].
class TotalExpensesProvider extends AutoDisposeProvider<double> {
  /// See also [totalExpenses].
  TotalExpensesProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        (ref) => totalExpenses(
          ref as TotalExpensesRef,
          startDate: startDate,
          endDate: endDate,
        ),
        from: totalExpensesProvider,
        name: r'totalExpensesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$totalExpensesHash,
        dependencies: TotalExpensesFamily._dependencies,
        allTransitiveDependencies:
            TotalExpensesFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  TotalExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(double Function(TotalExpensesRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: TotalExpensesProvider._internal(
        (ref) => create(ref as TotalExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _TotalExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalExpensesProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TotalExpensesRef on AutoDisposeProviderRef<double> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _TotalExpensesProviderElement extends AutoDisposeProviderElement<double>
    with TotalExpensesRef {
  _TotalExpensesProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as TotalExpensesProvider).startDate;
  @override
  DateTime? get endDate => (origin as TotalExpensesProvider).endDate;
}

String _$expensesByCategoryHash() =>
    r'23d1add7a3b57c22c8fe7571f0bd3750d7b68711';

/// See also [expensesByCategory].
@ProviderFor(expensesByCategory)
const expensesByCategoryProvider = ExpensesByCategoryFamily();

/// See also [expensesByCategory].
class ExpensesByCategoryFamily extends Family<Map<String, double>> {
  /// See also [expensesByCategory].
  const ExpensesByCategoryFamily();

  /// See also [expensesByCategory].
  ExpensesByCategoryProvider call({DateTime? startDate, DateTime? endDate}) {
    return ExpensesByCategoryProvider(startDate: startDate, endDate: endDate);
  }

  @override
  ExpensesByCategoryProvider getProviderOverride(
    covariant ExpensesByCategoryProvider provider,
  ) {
    return call(startDate: provider.startDate, endDate: provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expensesByCategoryProvider';
}

/// See also [expensesByCategory].
class ExpensesByCategoryProvider
    extends AutoDisposeProvider<Map<String, double>> {
  /// See also [expensesByCategory].
  ExpensesByCategoryProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        (ref) => expensesByCategory(
          ref as ExpensesByCategoryRef,
          startDate: startDate,
          endDate: endDate,
        ),
        from: expensesByCategoryProvider,
        name: r'expensesByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$expensesByCategoryHash,
        dependencies: ExpensesByCategoryFamily._dependencies,
        allTransitiveDependencies:
            ExpensesByCategoryFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  ExpensesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    Map<String, double> Function(ExpensesByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByCategoryProvider._internal(
        (ref) => create(ref as ExpensesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, double>> createElement() {
    return _ExpensesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByCategoryProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesByCategoryRef on AutoDisposeProviderRef<Map<String, double>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _ExpensesByCategoryProviderElement
    extends AutoDisposeProviderElement<Map<String, double>>
    with ExpensesByCategoryRef {
  _ExpensesByCategoryProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as ExpensesByCategoryProvider).startDate;
  @override
  DateTime? get endDate => (origin as ExpensesByCategoryProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
