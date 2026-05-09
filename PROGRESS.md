# Heshab Book App — SDLC Progress Tracker

> **Status**: 🟡 Phase 1 — Project Setup & Foundation
> **Last Updated**: 2026-05-09
> **Version**: 1.0.0 (pre-alpha)

---

## 📋 SDLC Phases Overview

| Phase | Name | Status |
|-------|------|--------|
| 0 | Project Initialization | ✅ Done |
| 1 | Foundation & Architecture Setup | ✅ Done |
| 2 | Core Database Layer (Drift + SQLite) | ✅ Done (tables created in Phase 1) |
| 3 | Authentication Module | ✅ Done |
| 4 | Shop Management Module | ✅ Done |
| 5 | Category / Sub-Category / Unit Module | ✅ Done |
| 6 | Product Management Module | ✅ Done |
| 7 | Supplier Management Module | ✅ Done |
| 8 | Retailer / Customer Management Module | 🟡 Next Up |
| 9 | Stock Management Module | ⬜ Pending |
| 10 | Billing System (Purchase + Sales + Return) | ⬜ Pending |
| 11 | Payment Management Module | ⬜ Pending |
| 12 | Ledger System | ⬜ Pending |
| 13 | Expense Management Module | ⬜ Pending |
| 14 | Profit & Loss Module | ⬜ Pending |
| 15 | Dashboard Module | ⬜ Pending |
| 16 | Reports Module | ⬜ Pending |
| 17 | Settings & Profile | ⬜ Pending |
| 18 | Cloud Sync (Future) | ⬜ Future |
| 19 | QA & Testing | ⬜ Pending |
| 20 | Release & Deployment | ⬜ Pending |

---

## 🔑 Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Completed & Verified |
| 🟡 | In Progress |
| ⬜ | Not Started |
| ❌ | Blocked / Error |
| 🔵 | Future Feature |

---

## Phase 0 — Project Initialization ✅

- [x] Flutter project created (`heshab_book_app`)
- [x] Git repository initialized
- [x] Initial commit done
- [x] README.md written with full business requirements
- [x] PROGRESS.md created (this file)
- [x] ERRORS.md created

---

## Phase 1 — Foundation & Architecture Setup ✅ COMPLETE

> Completed: 2026-05-09

### 1.1 — Dependencies Setup ✅

**All packages installed (97 packages):**
- [x] `flutter_riverpod` 2.6.1
- [x] `riverpod_annotation` 2.6.1
- [x] `drift` 2.28.2
- [x] `drift_flutter` 0.2.7
- [x] `sqlite3_flutter_libs` 0.5.42
- [x] `get_it` 8.3.0
- [x] `go_router` 15.1.3
- [x] `freezed_annotation` 2.4.4
- [x] `json_annotation` 4.9.0
- [x] `uuid` 4.5.3
- [x] `hive_flutter` 1.1.0
- [x] `dio` 5.9.2
- [x] `logger` 2.7.0
- [x] `intl` 0.20.2
- [x] `google_fonts` 6.3.3
- [x] `flutter_screenutil` 5.9.3
- [x] `crypto` 3.0.7
- [x] `flutter_localizations` (sdk)
- [x] `build_runner`, `riverpod_generator`, `drift_dev`, `freezed`, `json_serializable`

### 1.2 — Folder Structure ✅

- [x] `lib/core/constants/` — AppConstants, AppColors, AppTextStyles
- [x] `lib/config/theme/` — AppTheme (Light + Dark)
- [x] `lib/config/routes/` — GoRouter + RouteNames
- [x] `lib/config/di/` — GetIt ServiceLocator
- [x] `lib/database/tables/` — All 15 Drift tables
- [x] `lib/database/app_database.dart` — Drift AppDatabase
- [x] `lib/features/auth/presentation/screens/` — Splash, Login, Register stubs
- [x] `lib/features/dashboard/presentation/screens/` — Dashboard stub
- [x] `assets/` — images, icons, fonts, translations folders

### 1.3 — Theme System ✅

- [x] Material 3 + Poppins font
- [x] Full Light theme (colors, text, buttons, inputs, cards)
- [x] Dark theme structure

### 1.4 — Router Setup ✅

- [x] GoRouter with all route paths defined
- [x] RouteNames constants
- [x] Error page

### 1.5 — DI Setup ✅

- [x] GetIt container with AppDatabase singleton

### 1.6 — Database Layer ✅

All 15 Drift tables created with RULE-004 base fields:
- [x] `users` — users_table.dart
- [x] `shops` — shops_table.dart
- [x] `categories` + `sub_categories` — categories_table.dart
- [x] `units` — units_table.dart
- [x] `products` — products_table.dart
- [x] `stock_transactions` — stock_transactions_table.dart
- [x] `suppliers` — suppliers_table.dart
- [x] `retailers` — retailers_table.dart
- [x] `bills` + `bill_items` — bills_table.dart
- [x] `payments` — payments_table.dart
- [x] `ledgers` — ledgers_table.dart
- [x] `expenses` — expenses_table.dart
- [x] `sync_queue` — sync_queue_table.dart

### Code Gen ✅

- [x] `dart run build_runner build` — 0 errors
- [x] `flutter analyze` — **No issues found!**

---

## Phase 3 — Authentication Module ✅ COMPLETE

> Completed: 2026-05-09

### 3.1 — Data Layer ✅
- [x] `UserDao` & `ShopDao` created and registered in `AppDatabase`.
- [x] `AuthRepository` implemented with:
    - SHA-256 Password hashing with salt.
    - `register()` with duplicate check (mobile/email).
    - `login()` with hash verification.
    - `logout()` with session cleanup.
    - Hive session persistence (`keyIsLoggedIn`, `keyCurrentUserId`).

### 3.2 — Domain Layer (Riverpod) ✅
- [x] `AuthUser` & `AuthState` (sealed class) models.
- [x] `AuthNotifier` refactored to `Notifier` (Riverpod 2.x `@riverpod`).
- [x] `initialize()` to restore session on app start.
- [x] `isAuthenticatedProvider` & `currentUserProvider` convenience selectors.

### 3.3 — Presentation Layer (UI) ✅
- [x] **Splash Screen**: Animated logo, redirects via Auth Guard.
- [x] **Login Screen**: Premium UI with form validation, loading states, and error handling.
- [x] **Register Screen**: 5-field form with full validation.
- [x] **Shop Setup Screen**: Multi-step layout with Shop Type selection (Big Hall, Mix, Retail).
- [x] `AuthFormField` reusable widget with password visibility toggle.

### 3.4 — Routing & Security ✅
- [x] **GoRouter Auth Guard**:
    - Protects all internal routes.
    - Redirects to `/login` if unauthenticated.
    - Redirects to `/shop-setup` if new user hasn't created a shop.
    - Redirects to `/dashboard` if authenticated user tries to access login.

---

## Phase 5 — Category / Sub-Category / Unit Module ✅ COMPLETE

> Completed: 2026-05-09

### 5.1 — Data Layer ✅
- [x] `UnitRepository` implemented (CRUD for units).
- [x] `CategoryRepository` implemented (CRUD for categories and sub-categories).
- [x] Scoped all data to `shop_id` (RULE-005).

### 5.2 — Domain Layer (Riverpod) ✅
- [x] `shopUnitsProvider`: Stream of units for the active shop.
- [x] `shopCategoriesProvider`: Stream of main categories.
- [x] `subCategoriesProvider(categoryId)`: Family stream for sub-categories.

### 5.3 — DI Registration ✅
- [x] Registered both repositories in `service_locator.dart`.

---

## Phase 6 — Product Management Module ✅ COMPLETE

> Completed: 2026-05-09

### 6.1 — Data Layer ✅
- [x] `ProductRepository` implemented (CRUD).
- [x] **RULE-002 Violation Prevention**: `createProduct` now uses a transaction to simultaneously create the product AND its initial `StockTransaction` (opening stock).
- [x] Atomic updates for stock cache on product creation.

### 6.2 — Domain Layer (Riverpod) ✅
- [x] `shopProductsProvider`: Stream of all active products for the shop.
- [x] `searchProductsProvider(query)`: Reactive search using database `LIKE` queries for performance.
- [x] `lowStockProductsProvider`: Synchronous selector to quickly identify items below `minimumStockAlert`.

### 6.3 — DI & UI Prep ✅
- [x] `ProductRepository` registered in `service_locator.dart`.

---

## Phase 7 — Supplier Management Module 🟡 NEXT UP

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   └── utils/
├── config/
│   ├── theme/
│   ├── routes/
│   └── di/
├── database/
│   ├── app_database.dart
│   ├── daos/
│   └── tables/
├── shared/
│   ├── widgets/
│   └── models/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── dashboard/
│   ├── products/
│   ├── stock/
│   ├── billing/
│   ├── payments/
│   ├── suppliers/
│   ├── retailers/
│   ├── reports/
│   └── settings/
└── main.dart
```

- [ ] Create all feature folders
- [ ] Create `core/` folders
- [ ] Create `config/` folders
- [ ] Create `database/` folders

### 1.3 — Theme System

- [ ] Define color palette (primary, secondary, surface, background, error)
- [ ] Define text styles (heading, body, caption)
- [ ] Define spacing constants
- [ ] Light theme
- [ ] Dark theme support

### 1.4 — Router Setup (GoRouter)

Screens to route:
- [ ] `/` → Splash
- [ ] `/login` → Login
- [ ] `/register` → Register
- [ ] `/home` → Dashboard
- [ ] `/products` → Product List
- [ ] `/products/add` → Add Product
- [ ] `/products/:id` → Product Detail
- [ ] `/stock` → Stock Screen
- [ ] `/suppliers` → Supplier List
- [ ] `/retailers` → Retailer List
- [ ] `/bills` → Bill List
- [ ] `/bills/create` → Create Bill
- [ ] `/payments` → Payments
- [ ] `/ledger` → Ledger
- [ ] `/reports` → Reports
- [ ] `/settings` → Settings

### 1.5 — DI Setup (GetIt)

- [ ] Register `AppDatabase` as singleton
- [ ] Register all Repositories
- [ ] Register all Services

### 1.6 — Base Models

- [ ] `BaseEntity` with `id`, `uuid`, `createdAt`, `updatedAt`, `deletedAt`, `isDeleted`, `syncStatus`

---

## Phase 2 — Core Database Layer ⬜

> Setup all Drift tables and DAOs before any feature.

### Tables to Create:
- [ ] `users`
- [ ] `shops`
- [ ] `categories`
- [ ] `sub_categories`
- [ ] `units`
- [ ] `products`
- [ ] `stock_transactions`
- [ ] `suppliers`
- [ ] `retailers`
- [ ] `bills`
- [ ] `bill_items`
- [ ] `payments`
- [ ] `ledgers`
- [ ] `expenses`
- [ ] `reports_cache`
- [ ] `sync_queue`

### DAOs to Create:
- [ ] `UserDao`
- [ ] `ShopDao`
- [ ] `CategoryDao`
- [ ] `UnitDao`
- [ ] `ProductDao`
- [ ] `StockDao`
- [ ] `SupplierDao`
- [ ] `RetailerDao`
- [ ] `BillDao`
- [ ] `PaymentDao`
- [ ] `LedgerDao`
- [ ] `ExpenseDao`

---

## Phase 3 — Authentication Module ⬜

### Screens:
- [ ] Splash Screen
- [ ] Login Screen
- [ ] Register Screen
- [ ] Forgot Password Screen
- [ ] Profile Setup Screen

### Logic:
- [ ] `AuthProvider` (Riverpod)
- [ ] `UserRepository`
- [ ] `UserDao`
- [ ] Local auth state persistence (Hive)
- [ ] Form validation
- [ ] Password hashing (local)

---

## Phase 4 — Shop Management Module ⬜

- [ ] Create Shop Screen
- [ ] Shop List Screen
- [ ] Shop Selector (active shop context)
- [ ] `ShopProvider`
- [ ] `ShopRepository`

---

## Phase 5 — Category / Sub-Category / Unit Module ⬜

- [ ] Category CRUD Screen
- [ ] Sub-Category CRUD Screen
- [ ] Unit CRUD Screen (with defaults: KG, Gram, Meter, etc.)
- [ ] `CategoryProvider`
- [ ] `UnitProvider`

---

## Phase 6 — Product Management Module ⬜

- [ ] Product List Screen
- [ ] Add/Edit Product Screen
- [ ] Product Detail Screen
- [ ] Low Stock Alert display
- [ ] Barcode field (optional)
- [ ] `ProductProvider`
- [ ] `ProductRepository`

---

## Phase 7 — Supplier Management Module ✅ COMPLETE

> Completed: 2026-05-09

### 7.1 — Data Layer ✅
- [x] `SupplierRepository` implemented (CRUD).
- [x] **RULE-007 Violation Prevention**: `createSupplier` automatically creates an adjustment `Ledger` entry if an `openingBalance` is provided.
- [x] Atomic updates for `currentBalance` on creation.

### 7.2 — Domain Layer (Riverpod) ✅
- [x] `shopSuppliersProvider`: Stream of all active suppliers for the shop.
- [x] `searchSuppliersProvider(query)`: Reactive search by name, shop name, or phone.
- [x] `totalSupplierOwedProvider`: Selector to calculate the cumulative debt across all vendors.

### 7.3 — DI Registration ✅
- [x] `SupplierRepository` registered in `service_locator.dart`.

---

## Phase 8 — Retailer / Customer Management Module 🟡 NEXT UP

- [ ] Retailer List Screen
- [ ] Add/Edit Retailer Screen
- [ ] Retailer Detail Screen (with ledger summary)
- [ ] Credit limit support
- [ ] `RetailerProvider`
- [ ] `RetailerRepository`

---

## Phase 9 — Stock Management Module ⬜

> **RULE**: NEVER edit stock directly. Always create a `stock_transaction`.

- [ ] Stock Overview Screen
- [ ] Stock IN entry
- [ ] Stock OUT entry
- [ ] Stock Adjustment entry
- [ ] Damage Entry
- [ ] Return Entry
- [ ] Low Stock Alert list
- [ ] `StockProvider`
- [ ] `StockRepository`

---

## Phase 10 — Billing System ⬜

> Purchase Bill + Sales Bill + Return Bill + Expense Bill

- [ ] Bill List Screen
- [ ] Create Purchase Bill Screen
- [ ] Create Sales Bill Screen
- [ ] Create Return Bill Screen
- [ ] Bill Detail Screen (with items)
- [ ] Auto stock update on bill save
- [ ] Auto ledger entry on bill save
- [ ] Auto pending amount calculation
- [ ] Bill number auto-generation
- [ ] `BillProvider`
- [ ] `BillRepository`

---

## Phase 11 — Payment Management Module ⬜

- [ ] Payment List Screen
- [ ] Record Payment Screen (pay/receive)
- [ ] Payment History per Supplier/Retailer
- [ ] Auto ledger update on payment
- [ ] `PaymentProvider`
- [ ] `PaymentRepository`

---

## Phase 12 — Ledger System ⬜

- [ ] Ledger View per Supplier
- [ ] Ledger View per Retailer
- [ ] Debit/Credit/Balance display
- [ ] Date range filter
- [ ] `LedgerProvider`
- [ ] `LedgerRepository`

---

## Phase 13 — Expense Management Module ⬜

- [ ] Expense List Screen
- [ ] Add Expense Screen
- [ ] Expense Categories (Rent, Salary, Transport, etc.)
- [ ] `ExpenseProvider`
- [ ] `ExpenseRepository`

---

## Phase 14 — Profit & Loss Module ⬜

- [ ] P&L Summary Screen
- [ ] Gross Profit calculation
- [ ] Net Profit calculation (minus expenses)
- [ ] Monthly Profit graph
- [ ] Product-wise Profit
- [ ] `ProfitProvider`

---

## Phase 15 — Dashboard Module ⬜

### Cards:
- [ ] Total Stock Value
- [ ] Total Suppliers
- [ ] Total Retailers
- [ ] Total Bills
- [ ] Total Sales
- [ ] Total Purchase
- [ ] Total Receivable
- [ ] Total Payable
- [ ] Monthly Profit
- [ ] Expense Count
- [ ] Low Stock Alerts

---

## Phase 16 — Reports Module ⬜

- [ ] Sales Report (date range)
- [ ] Purchase Report (date range)
- [ ] Profit Report
- [ ] Expense Report
- [ ] Stock Report
- [ ] Low Stock Report
- [ ] Customer Ledger Report
- [ ] Supplier Ledger Report
- [ ] PDF export (future)
- [ ] Excel export (future)

---

## Phase 17 — Settings & Profile ⬜

- [ ] User Profile Edit
- [ ] Shop Settings
- [ ] Unit Defaults
- [ ] App Theme (Light/Dark)
- [ ] Language (future)
- [ ] Backup/Restore (future)

---

## Phase 18 — Cloud Sync (Future) 🔵

- [ ] API client (Dio)
- [ ] Sync queue processing
- [ ] Conflict resolution
- [ ] Real-time sync

---

## Phase 19 — QA & Testing ⬜

- [ ] Unit tests for all repositories
- [ ] Widget tests for key screens
- [ ] Integration tests for billing flow
- [ ] Performance test (large dataset)
- [ ] Edge case testing

---

## Phase 20 — Release & Deployment ⬜

- [ ] App icon
- [ ] Splash screen
- [ ] Android release APK
- [ ] iOS release IPA
- [ ] Store listing (future)

---

## 📅 Build Order (From README)

```
1. Auth
2. Shop setup
3. Categories/Subcategories/Units
4. Products
5. Suppliers/Retailers
6. Stock system
7. Billing system
8. Payments
9. Ledger
10. Reports
11. Dashboard
12. Cloud sync
```

---

## 🔗 Related Files

- [README.md](./README.md) — Full business requirements
- [ERRORS.md](./ERRORS.md) — All errors and fixes log
- [REQUIREMENTS_FROM_YOU.md](./REQUIREMENTS_FROM_YOU.md) — What I need from you
