// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentRepositoryHash() => r'5e2d26f971a9f8526fde1d4a5b29373d90d44e31';

/// See also [paymentRepository].
@ProviderFor(paymentRepository)
final paymentRepositoryProvider =
    AutoDisposeProvider<PaymentRepository>.internal(
      paymentRepository,
      name: r'paymentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentRepositoryRef = AutoDisposeProviderRef<PaymentRepository>;
String _$shopPaymentsHash() => r'25572a107fcb8b1c2a95d1048e27101344a56a30';

/// See also [shopPayments].
@ProviderFor(shopPayments)
final shopPaymentsProvider = AutoDisposeStreamProvider<List<Payment>>.internal(
  shopPayments,
  name: r'shopPaymentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shopPaymentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopPaymentsRef = AutoDisposeStreamProviderRef<List<Payment>>;
String _$partyPaymentsHash() => r'eb5a1cc385f37bacec4bf23ec6f26756f18a5425';

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

/// See also [partyPayments].
@ProviderFor(partyPayments)
const partyPaymentsProvider = PartyPaymentsFamily();

/// See also [partyPayments].
class PartyPaymentsFamily extends Family<AsyncValue<List<Payment>>> {
  /// See also [partyPayments].
  const PartyPaymentsFamily();

  /// See also [partyPayments].
  PartyPaymentsProvider call({int? supplierId, int? retailerId}) {
    return PartyPaymentsProvider(
      supplierId: supplierId,
      retailerId: retailerId,
    );
  }

  @override
  PartyPaymentsProvider getProviderOverride(
    covariant PartyPaymentsProvider provider,
  ) {
    return call(
      supplierId: provider.supplierId,
      retailerId: provider.retailerId,
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
  String? get name => r'partyPaymentsProvider';
}

/// See also [partyPayments].
class PartyPaymentsProvider extends AutoDisposeStreamProvider<List<Payment>> {
  /// See also [partyPayments].
  PartyPaymentsProvider({int? supplierId, int? retailerId})
    : this._internal(
        (ref) => partyPayments(
          ref as PartyPaymentsRef,
          supplierId: supplierId,
          retailerId: retailerId,
        ),
        from: partyPaymentsProvider,
        name: r'partyPaymentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$partyPaymentsHash,
        dependencies: PartyPaymentsFamily._dependencies,
        allTransitiveDependencies:
            PartyPaymentsFamily._allTransitiveDependencies,
        supplierId: supplierId,
        retailerId: retailerId,
      );

  PartyPaymentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.supplierId,
    required this.retailerId,
  }) : super.internal();

  final int? supplierId;
  final int? retailerId;

  @override
  Override overrideWith(
    Stream<List<Payment>> Function(PartyPaymentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PartyPaymentsProvider._internal(
        (ref) => create(ref as PartyPaymentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        supplierId: supplierId,
        retailerId: retailerId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Payment>> createElement() {
    return _PartyPaymentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PartyPaymentsProvider &&
        other.supplierId == supplierId &&
        other.retailerId == retailerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, supplierId.hashCode);
    hash = _SystemHash.combine(hash, retailerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PartyPaymentsRef on AutoDisposeStreamProviderRef<List<Payment>> {
  /// The parameter `supplierId` of this provider.
  int? get supplierId;

  /// The parameter `retailerId` of this provider.
  int? get retailerId;
}

class _PartyPaymentsProviderElement
    extends AutoDisposeStreamProviderElement<List<Payment>>
    with PartyPaymentsRef {
  _PartyPaymentsProviderElement(super.provider);

  @override
  int? get supplierId => (origin as PartyPaymentsProvider).supplierId;
  @override
  int? get retailerId => (origin as PartyPaymentsProvider).retailerId;
}

String _$totalPaymentsMadeHash() => r'7d817d2f80642f249d055d3a982d296b1ede5bde';

/// See also [totalPaymentsMade].
@ProviderFor(totalPaymentsMade)
final totalPaymentsMadeProvider = AutoDisposeProvider<double>.internal(
  totalPaymentsMade,
  name: r'totalPaymentsMadeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalPaymentsMadeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalPaymentsMadeRef = AutoDisposeProviderRef<double>;
String _$totalPaymentsReceivedHash() =>
    r'0f3eda364aabce442c3c5d4fe0349b65f853f147';

/// See also [totalPaymentsReceived].
@ProviderFor(totalPaymentsReceived)
final totalPaymentsReceivedProvider = AutoDisposeProvider<double>.internal(
  totalPaymentsReceived,
  name: r'totalPaymentsReceivedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalPaymentsReceivedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalPaymentsReceivedRef = AutoDisposeProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
