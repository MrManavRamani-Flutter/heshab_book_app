// lib/features/billing/presentation/providers/billing_notifier.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../domain/providers/bill_providers.dart';
import 'package:heshab_book_app/features/inventory/domain/providers/product_providers.dart';
import 'billing_state.dart';

part 'billing_notifier.g.dart';

@riverpod
class BillingNotifier extends _$BillingNotifier {
  @override
  BillingState build() {
    return const BillingState();
  }

  void setBillType(String type) {
    state = state.copyWith(billType: type, items: [], selectedPartyId: null);
  }

  void setParty(int? partyId) {
    state = state.copyWith(selectedPartyId: partyId);
  }

  void addItem(Product product, double quantity, double rate) async {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      final existing = state.items[existingIndex];
      final newQty = existing.quantity + quantity;
      final updatedItem = existing.copyWith(
        quantity: newQty,
        total: newQty * existing.rate,
      );
      
      final newItems = List<CartItem>.from(state.items);
      newItems[existingIndex] = updatedItem;
      state = state.copyWith(items: newItems);
    } else {
      final newItem = CartItem(
        product: product,
        quantity: quantity,
        rate: rate,
        total: quantity * rate,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }

    // Fetch suggestions based on matching code
    if (product.matchingCode != null && product.matchingCode!.isNotEmpty) {
      final shop = ref.read(activeShopProvider);
      if (shop != null) {
        final productRepo = ref.read(productRepositoryProvider);
        final matches = await productRepo.getMatchingProducts(shop.id, product.matchingCode!, product.id);
        state = state.copyWith(suggestions: matches);
      }
    } else {
      state = state.copyWith(suggestions: []);
    }
  }

  void removeItem(int productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  void updateItemQuantity(int productId, double quantity) {
    final newItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity, total: quantity * item.rate);
      }
      return item;
    }).toList();
    state = state.copyWith(items: newItems);
  }

  void setDiscount(double amount) => state = state.copyWith(discountAmount: amount);
  void setTax(double amount) => state = state.copyWith(taxAmount: amount);
  void setPaidAmount(double amount) => state = state.copyWith(paidAmount: amount);

  Future<bool> saveBill() async {
    if (state.items.isEmpty) {
      state = state.copyWith(errorMessage: 'Please add at least one item');
      return false;
    }

    final activeShop = ref.read(activeShopProvider);
    if (activeShop == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final billRepo = ref.read(billRepositoryProvider);
      
      final billItems = state.items.map((item) => BillItemsCompanion.insert(
        uuid: '', // Generated in repo
        billId: 0, // Placeholder
        productUuid: item.product.uuid,
        productName: item.product.name,
        quantity: item.quantity,
        salePrice: item.rate,
        totalAmount: item.total,
        purchasePrice: Value(item.product.purchasePrice),
      )).toList();

      await billRepo.createBill(
        shopId: activeShop.id,
        billType: state.billType,
        billDate: DateTime.now(),
        supplierId: state.billType == 'purchase' ? state.selectedPartyId : null,
        retailerId: state.billType == 'sales' ? state.selectedPartyId : null,
        items: billItems,
        discountAmount: state.discountAmount,
        taxAmount: state.taxAmount,
        paidAmount: state.paidAmount,
      );

      state = const BillingState(); // Reset
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
