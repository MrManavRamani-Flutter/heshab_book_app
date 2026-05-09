# Heshab Book App — SDLC Progress Tracker

> **Status**: 🟡 Phase 1 — Project Setup & Foundation
> **Last Updated**: 2026-05-09
> **Version**: 1.0.0 (pre-alpha)

---

## 📋 SDLC Phases Overview

| Phase | Name | Status |
|-------|------|--------|
| 0 | Project Initialization | ✅ Done |
| 1 | Foundation & Architecture Setup | 🟡 In Progress |
| 2 | Core Database Layer (Drift + SQLite) | ⬜ Pending |
| 3 | Authentication Module | ⬜ Pending |
| 4 | Shop Management Module | ⬜ Pending |
| 5 | Category / Sub-Category / Unit Module | ⬜ Pending |
| 6 | Product Management Module | ⬜ Pending |
| 7 | Supplier Management Module | ⬜ Pending |
| 8 | Retailer / Customer Management Module | ⬜ Pending |
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

## Phase 1 — Foundation & Architecture Setup 🟡

> Goal: Setup the correct folder structure, all dependencies, routing, DI, and theme before writing any feature code.

### 1.1 — Dependencies Setup

**Required from user (see REQUIREMENTS_FROM_YOU.md):**
- Confirm Flutter SDK version installed
- Confirm target platforms (iOS / Android / Both)

**Packages to add:**
- [ ] `flutter_riverpod` — State management
- [ ] `riverpod_annotation` — Riverpod code gen
- [ ] `drift` — SQLite ORM
- [ ] `drift_flutter` — Drift Flutter adapter
- [ ] `sqlite3_flutter_libs` — SQLite native libs
- [ ] `get_it` — Dependency injection
- [ ] `go_router` — Navigation
- [ ] `freezed` — Immutable model generation
- [ ] `freezed_annotation` — Freezed annotations
- [ ] `json_annotation` — JSON serialization
- [ ] `uuid` — UUID generation
- [ ] `hive_flutter` — Local key-value storage
- [ ] `dio` — HTTP client (future sync)
- [ ] `logger` — Logging
- [ ] `intl` — Date/number formatting
- [ ] `google_fonts` — Typography
- [ ] `flutter_screenutil` — Responsive UI

**Dev packages:**
- [ ] `build_runner` — Code generation
- [ ] `riverpod_generator` — Riverpod code gen
- [ ] `drift_dev` — Drift code gen
- [ ] `freezed` (dev) — Model gen
- [ ] `json_serializable` — JSON gen

### 1.2 — Folder Structure Setup

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

## Phase 7 — Supplier Management Module ⬜

- [ ] Supplier List Screen
- [ ] Add/Edit Supplier Screen
- [ ] Supplier Detail Screen (with ledger summary)
- [ ] `SupplierProvider`
- [ ] `SupplierRepository`

---

## Phase 8 — Retailer / Customer Management Module ⬜

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
