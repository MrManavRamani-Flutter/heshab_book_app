// lib/features/billing/presentation/providers/billing_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../database/app_database.dart';

part 'billing_state.freezed.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required Product product,
    required double quantity,
    required double rate,
    required double total,
    String? note,
  }) = _CartItem;
}

@freezed
class BillingState with _$BillingState {
  const factory BillingState({
    @Default([]) List<CartItem> items,
    int? selectedPartyId, // supplier or retailer
    @Default('sales') String billType,
    @Default(0.0) double discountAmount,
    @Default(0.0) double taxAmount,
    @Default(0.0) double paidAmount,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _BillingState;

  const BillingState._();

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get totalAmount => subtotal - discountAmount + taxAmount;
  double get pendingAmount => totalAmount - paidAmount;
}
