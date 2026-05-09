# Heshab Book App — Production Level Flutter App Planning

You are building a **complete business हिसाब (accounting + stock + billing + payment + profit/loss)** system for:

* Big Hall Seller (Wholesale Supplier)
* Mix Hall Seller + Retail
* Retail Only Shop

This app should support:

* Multiple shop owners
* Multiple business types
* Offline-first architecture
* SQLite database
* Future cloud sync support
* Dynamic/custom business management

Your app is basically:

> **Inventory + Billing + Ledger + Payment + Profit/Loss + Stock + Customer + Supplier Management System**

---

# 1. Core Business Flow

## Real World Flow

### Flow 1 — Big Hall Seller → Your Shop

You purchase stock from wholesaler.

Example:

* 100 blouse pieces
* 50 chaniya
* 30 ashter cloth

You create:

* Purchase Bill
* Stock Entry
* Payment Pending
* Supplier Ledger

---

### Flow 2 — Your Shop → Retailer

Retailer purchases from your stock.

You create:

* Sales Bill
* Retailer Ledger
* Pending Amount
* Payment Receive
* Profit Calculation

---

### Flow 3 — Internal Business Tracking

System should track:

* Profit
* Loss
* Expenses
* Stock
* Damaged Items
* Pending Payments
* Cash Flow
* Total Receivable
* Total Payable

---

# 2. Main User Roles

## 1. Main Admin/User

Owner of shop.

Can:

* Manage all data
* Add users
* Add products
* Create bills
* View reports
* Manage stock
* Manage suppliers/customers

---

## 2. Big Hall Seller (Supplier)

Supplier from whom stock is purchased.

Need:

* Ledger
* Pending payments
* Purchase history
* Product history

---

## 3. Retailer / Hall Sell Customer

Customer buying from your shop.

Need:

* Sales history
* Payment history
* Pending amount
* Order tracking

---

# 3. App Modules

# A. Authentication Module

## Features

* Register
* Login
* Forgot password
* Set profile
* Shop setup
* Multiple business support

## Data

* Name
* Mobile
* Email
* Password
* Shop Name
* Shop Type
* GST (optional)
* Profile Photo
* Created At

---

# B. Shop Management Module

One user can create multiple shops.

Example:

* Electric Shop
* Cloth Material Shop

Each shop has separate:

* Products
* Stock
* Bills
* Customers
* Suppliers
* Ledger

---

# C. Product Management Module

## Product Fields

| Field               | Type     |
| ------------------- | -------- |
| Product ID          | UUID     |
| Product Name        | String   |
| Product Code        | String   |
| Barcode             | Optional |
| Category ID         | FK       |
| Sub Category ID     | FK       |
| Unit ID             | FK       |
| Original Price      | Double   |
| Wholesale Price     | Double   |
| Retail Price        | Double   |
| Custom Price        | Double   |
| Purchase Price      | Double   |
| Sell Price          | Double   |
| Current Stock       | Double   |
| Minimum Stock Alert | Double   |
| Is Active           | Bool     |
| Created At          | DateTime |

---

# D. Dynamic Unit Management

User can create custom units.

## Default Units

* KG
* Gram
* Meter
* Inch
* Piece
* Qty
* Liter
* Box
* Packet

## Custom Units

User can create:

* Roll
* Bundle
* Pair
* Dozen

---

# E. Category Management

## Category

Examples:

* Cloth
* Electric
* Grocery

## Sub Category

Examples:

* Blouse
* Chaniya
* Wire
* Bulb

---

# F. Stock Management

## Features

* Stock IN
* Stock OUT
* Stock Adjustment
* Damage Entry
* Return Entry
* Low Stock Alert

## Stock Movement Types

| Type       |
| ---------- |
| Purchase   |
| Sale       |
| Return     |
| Damage     |
| Adjustment |

---

# G. Supplier Management

## Fields

* Name
* Shop Name
* Phone
* Alternate Phone
* Email
* GST Number
* Bank Details
* Address
* Home Address
* Notes
* Opening Balance
* Created At

---

# H. Retailer / Customer Management

Same structure as supplier.

Additional:

* Credit Limit
* Customer Type

---

# I. Billing System

# Bill Types

| Type          |
| ------------- |
| Purchase Bill |
| Sales Bill    |
| Return Bill   |
| Expense Bill  |

---

# Purchase Bill Flow

Supplier → Your Shop

Updates:

* Stock increases
* Payable increases

---

# Sales Bill Flow

Your Shop → Retailer

Updates:

* Stock decreases
* Receivable increases
* Profit updates

---

# J. Payment Management

## Two Side Tracking

### You Need To Pay

(Big Hall Seller)

### You Need To Receive

(Retailer)

---

# Payment Status

* Paid
* Partial
* Pending

---

# K. Ledger System

Every supplier/customer has:

* Debit
* Credit
* Balance
* History

---

# L. Expense Management

Track:

* Rent
* Salary
* Transport
* Electricity
* Misc Expense

---

# M. Profit & Loss Module

## Profit Formula

\text{Profit} = \text{Selling Price} - \text{Purchase Price}

---

## Track

* Gross Profit
* Net Profit
* Expense Loss
* Monthly Profit
* Product Wise Profit

---

# N. Dashboard Module

# Dashboard Cards

* Total Shops
* Total Stock Value
* Total Suppliers
* Total Retailers
* Total Bills
* Total Sales
* Total Purchase
* Total Receivable
* Total Payable
* Monthly Profit
* Expense Count

---

# O. Reports Module

## Reports

* Sales Report
* Purchase Report
* Profit Report
* Expense Report
* Stock Report
* Low Stock Report
* Customer Ledger
* Supplier Ledger

---

# P. Offline First Architecture

## Current

* SQLite local DB

## Future

* API sync
* Cloud backup
* Real-time sync

So architecture must support:

* Sync Queue
* Offline writes
* UUID based records

---

# 4. Recommended Flutter Architecture

# Architecture

```text
Presentation Layer
    ↓
Controller / State Layer
    ↓
Repository Layer
    ↓
Local Database Layer
    ↓
SQLite
```

---

# 5. Recommended Tech Stack

| Purpose              | Technology        |
| -------------------- | ----------------- |
| App                  | Flutter           |
| State Management     | Riverpod          |
| Local DB             | SQLite            |
| ORM                  | Drift             |
| Dependency Injection | GetIt             |
| Routing              | GoRouter          |
| Model Generation     | Freezed           |
| JSON                 | json_serializable |
| Local Storage        | Hive              |
| Sync                 | Dio               |
| Logging              | Logger            |

---

# 6. Recommended Folder Structure

```text
lib/
│
├── core/
├── config/
├── database/
├── services/
├── shared/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── products/
│   ├── stock/
│   ├── billing/
│   ├── payments/
│   ├── suppliers/
│   ├── retailers/
│   ├── reports/
│   └── settings/
│
├── models/
├── repositories/
├── providers/
├── routes/
└── main.dart
```

---

# 7. Database Design (Production Level)

# Main Tables

| Table              |
| ------------------ |
| users              |
| shops              |
| categories         |
| sub_categories     |
| units              |
| products           |
| stock_transactions |
| suppliers          |
| retailers          |
| bills              |
| bill_items         |
| payments           |
| ledgers            |
| expenses           |
| reports_cache      |
| sync_queue         |

---

# 8. Database Design Rules (VERY IMPORTANT)

# Use UUID Everywhere

Never use only auto increment IDs.

Use:

```text
uuid
```

Because future sync requires unique IDs.

---

# Every Table Must Have

| Field       |
| ----------- |
| id          |
| uuid        |
| created_at  |
| updated_at  |
| deleted_at  |
| is_deleted  |
| sync_status |

---

# 9. SQLite Best Practices

# Use Singleton Database

Only one database instance.

Example:

```dart
class AppDatabase {
  static AppDatabase? _instance;

  AppDatabase._internal();

  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }
}
```

---

# 10. State Management

# Recommended

## Riverpod

Why:

* Scalable
* Testable
* Clean
* Production ready

---

# Provider Structure

```text
ProductProvider
BillProvider
PaymentProvider
DashboardProvider
StockProvider
AuthProvider
```

---

# 11. Bill Structure

# Bill Header

| Field             |
| ----------------- |
| Bill Number       |
| Supplier/Customer |
| Bill Type         |
| Total Amount      |
| Paid Amount       |
| Pending Amount    |
| Status            |
| Created At        |

---

# Bill Items

| Field    |
| -------- |
| Product  |
| Quantity |
| Unit     |
| Price    |
| Discount |
| Tax      |
| Total    |

---

# 12. Stock Calculation

## Stock Formula

\text{Current Stock} = \text{Stock In} - \text{Stock Out}

---

# 13. Pending Amount Formula

\text{Pending Amount} = \text{Total Bill} - \text{Paid Amount}

---

# 14. Profit Calculation System

Per Product:

* Purchase price
* Selling price
* Discount
* Expense allocation

Per Bill:

* Gross profit
* Net profit

---

# 15. Future Ready Features

# IMPORTANT

Prepare now for future:

## Future Features

* Multi device sync
* Cloud backup
* GST billing
* Barcode scanner
* Thermal printing
* WhatsApp invoice
* Excel export
* PDF invoice
* Multi language
* Dark mode
* Role permissions
* Staff management

---

# 16. Recommended UI Screens

# Auth

* Splash
* Login
* Register

# Main

* Dashboard
* Product List
* Product Details
* Stock Screen
* Supplier List
* Retailer List
* Bill List
* Create Bill
* Payment Screen
* Ledger Screen
* Reports Screen
* Settings

---

# 17. Important Business Logic

# NEVER directly edit stock

Always create:

```text
stock_transactions
```

Because:

* History remains safe
* Audit possible
* Profit tracking correct

---

# 18. Recommended Database Relationships

```text
Shop
 ├── Products
 ├── Suppliers
 ├── Retailers
 ├── Bills
 ├── Payments
 └── Expenses
```

---

# 19. Sync Ready Database Structure

Every table should support:

| Field          |
| -------------- |
| local_id       |
| server_id      |
| sync_status    |
| last_synced_at |

---

# 20. Final Recommendation

This app should be built as:

# Offline First ERP Style Business App

NOT simple billing app.

Because your requirements include:

* Accounting
* Stock
* Supplier
* Retailer
* Multi shop
* Profit/loss
* Ledger
* Payment tracking
* Inventory
* Reporting

So architecture must be:

* Modular
* Scalable
* Sync ready
* Clean architecture based

---

# Best Final Stack

| Layer         | Tech         |
| ------------- | ------------ |
| UI            | Flutter      |
| State         | Riverpod     |
| Database      | Drift SQLite |
| API           | Dio          |
| Local Storage | Hive         |
| DI            | GetIt        |
| Models        | Freezed      |

---

# Suggested Next Step

Build in this order:

1. Auth
2. Shop setup
3. Categories/Subcategories
4. Units
5. Products
6. Suppliers/Retailers
7. Stock system
8. Billing system
9. Payments
10. Ledger
11. Reports
12. Dashboard
13. Cloud sync
