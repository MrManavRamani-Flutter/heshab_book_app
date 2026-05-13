# 📒 Heshab Book — Offline-First Business ERP

> **An offline-first business accounting, billing, inventory & ledger system built for textile & retail shop owners — powered by Flutter + Drift (SQLite).**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey)](https://flutter.dev)
[![DB](https://img.shields.io/badge/Database-SQLite%20%2F%20Drift-green)](https://drift.simonbinder.eu/)
[![State](https://img.shields.io/badge/State-Riverpod%20v2-orange)](https://riverpod.dev)

---

## 🏪 Built For

| Business Type | Description |
|---|---|
| **Big Hall Seller** | Wholesale supplier managing bulk purchase & party ledger |
| **Mix Hall + Retail** | Multi-type inventory with supplier & retail billing |
| **Retail Shop** | Pure retail with customer billing, stock & profit tracking |

Specifically optimised for **textile businesses** managing materials like:
- Chaniya Cotton (Qty)
- Silk Chaniya (Meter/Qty)
- Ashtar cloth (Meter)
- Blouse Piece (Meter)
- Fancy Blouse Piece (Meter)

---

## ✅ Implemented Features (Current SDLC Status)

### 🔐 Authentication
- [x] User Registration (name, email, phone, password)
- [x] Login with hashed password (crypto)
- [x] Persistent auth session via Hive
- [x] Shop setup on first login
- [x] Multi-shop support (one user → multiple shops)

### 🏠 Dashboard
- [x] Today's Sales summary card
- [x] Pending Receivables card
- [x] Stock Value card
- [x] Low Stock alert count
- [x] Revenue Trends chart (FL Chart)
- [x] Recent Transactions list

### 📦 Inventory / Product Management
- [x] Add Product (name, code, purchase price, retail price, unit, category)
- [x] Edit Product — race-condition-free form (FutureBuilder pattern, idempotent controller loading)
- [x] Delete Product
- [x] Stock status badges (In Stock / Low Stock / Out of Stock)
- [x] Opening stock entry on creation
- [x] Minimum stock alert threshold
- [x] Real-time product list via Drift Stream + Riverpod

### 🧵 Textile-Specific Units & Categories
- [x] Custom units per shop (Meter, Qty, Piece, Roll, Bundle, etc.)
- [x] Add unit inline from product form
- [x] Custom categories & sub-categories per shop
- [x] Add category inline from product form

### 🧾 Billing System
- [x] Sales Bill creation screen
- [x] Add bill items (product, qty, price)
- [x] Bill total calculation
- [ ] Purchase Bill (planned)
- [ ] Return Bill (planned)
- [ ] PDF export (planned)

### 👥 Party Management (Customers & Suppliers)
- [x] Customers tab with balance display (Receivable/Payable)
- [x] Suppliers tab
- [x] Add Customer / Supplier form
- [x] Party balance tracking (current balance)

### 📈 Stock Management
- [x] Stock transaction model (Purchase / Sale / Return / Damage / Adjustment)
- [x] Stock history per product
- [x] Shop-wide stock history
- [ ] Stock adjustment UI (planned)
- [ ] Damage entry UI (planned)

### 💰 Payments & Ledger
- [x] Payment repository (record, list)
- [x] Ledger repository (debit/credit/balance)
- [ ] Payment entry UI (planned)
- [ ] Customer/Supplier ledger UI (planned)

### 📊 Reports
- [x] Report repository (sales, purchase, profit data)
- [ ] Sales Report UI (planned)
- [ ] Profit/Loss Report UI (planned)
- [ ] Stock Report UI (planned)

### ⚙️ Settings
- [x] Shop Profile (view & edit)
- [x] Logout
- ~~Cloud/Google Drive Backup~~ *(removed — local-only for now)*

---

## 🏗️ Architecture

```
Presentation Layer  (Flutter Widgets, Riverpod ConsumerWidget)
        ↓
State Layer         (Riverpod Providers, AsyncNotifiers)
        ↓
Repository Layer    (ProductRepository, BillRepository, etc.)
        ↓
DAO Layer           (Drift DAOs — type-safe SQL queries)
        ↓
SQLite              (Drift ORM — single AppDatabase singleton)
```

### Key Patterns
- **Offline-First**: All data lives in SQLite. No network required.
- **Stream-based UI**: Riverpod watches Drift Streams → UI rebuilds automatically on data change.
- **Race-Condition-Safe Edit Forms**: `FutureBuilder` + idempotent `_dataLoaded` guard ensures controller population happens once, before user interaction.
- **Unique Hero Tags**: All FABs have unique `heroTag` to prevent navigation animation conflicts.

---

## 🛠️ Tech Stack

| Purpose | Library | Version |
|---|---|---|
| Framework | Flutter | 3.x |
| State Management | flutter_riverpod | ^2.6.1 |
| Database ORM | drift + drift_flutter | ^2.26.1 |
| SQLite Native | sqlite3_flutter_libs | ^0.5.30 |
| Routing | go_router | ^15.1.2 |
| Dependency Injection | get_it | ^8.0.3 |
| Local Storage (auth/settings) | hive_flutter | ^1.1.0 |
| Charts | fl_chart | ^1.2.0 |
| Animations | flutter_animate | ^4.5.2 |
| Responsive UI | flutter_screenutil | ^5.9.3 |
| Fonts | google_fonts | ^6.2.1 |
| HTTP (future use) | dio | ^5.8.0+1 |
| Code Generation | build_runner, riverpod_generator, drift_dev, freezed | latest |

---

## 📁 Folder Structure

```
lib/
├── config/
│   ├── di/           # GetIt service locator
│   ├── routes/       # GoRouter routes & route names
│   └── theme/        # App colours, typography
│
├── core/
│   ├── constants/    # AppConstants (Hive box keys, etc.)
│   ├── theme/        # AppColors, gradients, glassmorphism
│   └── widgets/      # Shared widgets (GlassCard, MainScreen, etc.)
│
├── database/
│   ├── app_database.dart   # Drift AppDatabase (singleton)
│   ├── daos/               # UserDao, ShopDao
│   └── tables/             # All Drift table definitions
│
└── features/
    ├── auth/               # Login, Register, ShopSetup
    ├── billing/            # Sales bill creation
    ├── dashboard/          # Dashboard screen + stats
    ├── expenses/           # Expense tracking (repo ready)
    ├── inventory/          # Products, Units, Categories, Stock
    ├── ledger/             # Ledger repo
    ├── parties/            # Customers & Suppliers
    ├── payments/           # Payment repo
    ├── reports/            # Report repo
    ├── settings/           # Settings screen
    └── shops/              # Shop management & active shop provider
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.11.3`
- Dart SDK `^3.11.3`
- Xcode (for iOS) or Android Studio (for Android)
- CocoaPods (for iOS)

### Setup

```bash
# Clone the repository
git clone https://github.com/purepixel36/heshab_book_app.git
cd heshab_book_app

# Install dependencies
flutter pub get

# Run code generation (Drift, Riverpod, Freezed)
dart run build_runner build --delete-conflicting-outputs

# Run on iOS simulator
flutter run -d "iPhone 17 Pro Max"

# Run on Android
flutter run -d android
```

---

## 🧪 Testing

The app uses Flutter Driver for integration testing.

```bash
# Run driver tests
flutter drive --driver=lib/main_driver.dart --target=lib/main.dart -d <device-id>
```

### Tested Features (Automated)
- ✅ Product Create (Add form → save → verify in list)
- ✅ Product Edit (Open form → update name/price → save → verify in list)
- ✅ Dashboard data display
- ✅ Settings screen (Cloud Backup removed, Account section present)
- ✅ Parties screen (Customers/Suppliers tabs)

---

## 🗄️ Database Schema (Key Tables)

| Table | Purpose |
|---|---|
| `users` | App users (auth) |
| `shops` | One user → many shops |
| `products` | Product catalog per shop |
| `units` | Custom units per shop |
| `categories` | Product categories per shop |
| `sub_categories` | Sub-categories per category |
| `stock_transactions` | Every stock movement (audit trail) |
| `suppliers` | Supplier party records |
| `retailers` | Customer/retailer records |
| `bills` | Bill headers (sales/purchase) |
| `bill_items` | Line items per bill |
| `payments` | Payment records |
| `ledgers` | Double-entry ledger per party |
| `expenses` | Expense entries |

---

## 🛣️ Roadmap

### Phase 1 — Core CRUD ✅ Done
- Auth, Shop setup, Product CRUD, basic UI

### Phase 2 — Billing & Parties ✅ In Progress
- Sales Bill, Customer/Supplier management

### Phase 3 — Stock & Ledger 🔄 Next
- Stock adjustment UI, Party ledger screens, Payment entry

### Phase 4 — Reports & Analytics 📅 Planned
- Sales reports, Profit/Loss, Low stock reports

### Phase 5 — Polish & Production 📅 Planned
- PDF invoice, Barcode scanner, Thermal print support
- GST billing, Multi-language (Gujarati/Hindi)
- Excel export, WhatsApp share

---

## 📝 Business Logic Rules

1. **Never edit stock directly** — always create a `StockTransaction` record for full audit trail
2. **Profit = Retail Price − Purchase Price** per item
3. **Pending Amount = Total Bill − Paid Amount**
4. **All records are soft-deleted** (is_deleted flag) for data safety
5. **UUID-based IDs** on all records for future cloud sync readiness
6. **Offline First** — works fully without internet; network not required

---

## 👤 Author

**Manav Ramani** — [purepixel36](https://github.com/purepixel36)

> Built with ❤️ for small & medium textile businesses in Gujarat, India.
