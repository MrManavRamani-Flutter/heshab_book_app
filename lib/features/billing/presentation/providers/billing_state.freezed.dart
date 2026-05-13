// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CartItem {
  Product get product => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get rate => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({
    Product product,
    double quantity,
    double rate,
    double total,
    String? note,
  });
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = freezed,
    Object? quantity = null,
    Object? rate = null,
    Object? total = null,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            product: freezed == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as Product,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            rate: null == rate
                ? _value.rate
                : rate // ignore: cast_nullable_to_non_nullable
                      as double,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
    _$CartItemImpl value,
    $Res Function(_$CartItemImpl) then,
  ) = __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Product product,
    double quantity,
    double rate,
    double total,
    String? note,
  });
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
    _$CartItemImpl _value,
    $Res Function(_$CartItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = freezed,
    Object? quantity = null,
    Object? rate = null,
    Object? total = null,
    Object? note = freezed,
  }) {
    return _then(
      _$CartItemImpl(
        product: freezed == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        rate: null == rate
            ? _value.rate
            : rate // ignore: cast_nullable_to_non_nullable
                  as double,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CartItemImpl implements _CartItem {
  const _$CartItemImpl({
    required this.product,
    required this.quantity,
    required this.rate,
    required this.total,
    this.note,
  });

  @override
  final Product product;
  @override
  final double quantity;
  @override
  final double rate;
  @override
  final double total;
  @override
  final String? note;

  @override
  String toString() {
    return 'CartItem(product: $product, quantity: $quantity, rate: $rate, total: $total, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            const DeepCollectionEquality().equals(other.product, product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(product),
    quantity,
    rate,
    total,
    note,
  );

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);
}

abstract class _CartItem implements CartItem {
  const factory _CartItem({
    required final Product product,
    required final double quantity,
    required final double rate,
    required final double total,
    final String? note,
  }) = _$CartItemImpl;

  @override
  Product get product;
  @override
  double get quantity;
  @override
  double get rate;
  @override
  double get total;
  @override
  String? get note;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BillingState {
  List<CartItem> get items => throw _privateConstructorUsedError;
  List<Product> get suggestions => throw _privateConstructorUsedError;
  int? get selectedPartyId =>
      throw _privateConstructorUsedError; // supplier or retailer
  String get billType => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of BillingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingStateCopyWith<BillingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingStateCopyWith<$Res> {
  factory $BillingStateCopyWith(
    BillingState value,
    $Res Function(BillingState) then,
  ) = _$BillingStateCopyWithImpl<$Res, BillingState>;
  @useResult
  $Res call({
    List<CartItem> items,
    List<Product> suggestions,
    int? selectedPartyId,
    String billType,
    double discountAmount,
    double taxAmount,
    double paidAmount,
    bool isLoading,
    String? errorMessage,
  });
}

/// @nodoc
class _$BillingStateCopyWithImpl<$Res, $Val extends BillingState>
    implements $BillingStateCopyWith<$Res> {
  _$BillingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? suggestions = null,
    Object? selectedPartyId = freezed,
    Object? billType = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? paidAmount = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartItem>,
            suggestions: null == suggestions
                ? _value.suggestions
                : suggestions // ignore: cast_nullable_to_non_nullable
                      as List<Product>,
            selectedPartyId: freezed == selectedPartyId
                ? _value.selectedPartyId
                : selectedPartyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            billType: null == billType
                ? _value.billType
                : billType // ignore: cast_nullable_to_non_nullable
                      as String,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillingStateImplCopyWith<$Res>
    implements $BillingStateCopyWith<$Res> {
  factory _$$BillingStateImplCopyWith(
    _$BillingStateImpl value,
    $Res Function(_$BillingStateImpl) then,
  ) = __$$BillingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CartItem> items,
    List<Product> suggestions,
    int? selectedPartyId,
    String billType,
    double discountAmount,
    double taxAmount,
    double paidAmount,
    bool isLoading,
    String? errorMessage,
  });
}

/// @nodoc
class __$$BillingStateImplCopyWithImpl<$Res>
    extends _$BillingStateCopyWithImpl<$Res, _$BillingStateImpl>
    implements _$$BillingStateImplCopyWith<$Res> {
  __$$BillingStateImplCopyWithImpl(
    _$BillingStateImpl _value,
    $Res Function(_$BillingStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? suggestions = null,
    Object? selectedPartyId = freezed,
    Object? billType = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? paidAmount = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$BillingStateImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartItem>,
        suggestions: null == suggestions
            ? _value._suggestions
            : suggestions // ignore: cast_nullable_to_non_nullable
                  as List<Product>,
        selectedPartyId: freezed == selectedPartyId
            ? _value.selectedPartyId
            : selectedPartyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        billType: null == billType
            ? _value.billType
            : billType // ignore: cast_nullable_to_non_nullable
                  as String,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BillingStateImpl extends _BillingState {
  const _$BillingStateImpl({
    final List<CartItem> items = const [],
    final List<Product> suggestions = const [],
    this.selectedPartyId,
    this.billType = 'sales',
    this.discountAmount = 0.0,
    this.taxAmount = 0.0,
    this.paidAmount = 0.0,
    this.isLoading = false,
    this.errorMessage,
  }) : _items = items,
       _suggestions = suggestions,
       super._();

  final List<CartItem> _items;
  @override
  @JsonKey()
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<Product> _suggestions;
  @override
  @JsonKey()
  List<Product> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  final int? selectedPartyId;
  // supplier or retailer
  @override
  @JsonKey()
  final String billType;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double paidAmount;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BillingState(items: $items, suggestions: $suggestions, selectedPartyId: $selectedPartyId, billType: $billType, discountAmount: $discountAmount, taxAmount: $taxAmount, paidAmount: $paidAmount, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._suggestions,
              _suggestions,
            ) &&
            (identical(other.selectedPartyId, selectedPartyId) ||
                other.selectedPartyId == selectedPartyId) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_suggestions),
    selectedPartyId,
    billType,
    discountAmount,
    taxAmount,
    paidAmount,
    isLoading,
    errorMessage,
  );

  /// Create a copy of BillingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingStateImplCopyWith<_$BillingStateImpl> get copyWith =>
      __$$BillingStateImplCopyWithImpl<_$BillingStateImpl>(this, _$identity);
}

abstract class _BillingState extends BillingState {
  const factory _BillingState({
    final List<CartItem> items,
    final List<Product> suggestions,
    final int? selectedPartyId,
    final String billType,
    final double discountAmount,
    final double taxAmount,
    final double paidAmount,
    final bool isLoading,
    final String? errorMessage,
  }) = _$BillingStateImpl;
  const _BillingState._() : super._();

  @override
  List<CartItem> get items;
  @override
  List<Product> get suggestions;
  @override
  int? get selectedPartyId; // supplier or retailer
  @override
  String get billType;
  @override
  double get discountAmount;
  @override
  double get taxAmount;
  @override
  double get paidAmount;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of BillingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingStateImplCopyWith<_$BillingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
