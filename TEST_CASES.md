# Heshab Book ERP - Comprehensive Test Report

This document tracks the status of all functional and integration test cases for the Heshab Book application.

## 1. Authentication & Onboarding
| Test Case ID | Feature | Description | Status | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| AUTH-001 | Registration | Create new account with mobile and password | ✅ Verified | 2026-05-13 |
| AUTH-002 | Login | Authenticate existing user via mobile/password | ✅ Verified | 2026-05-13 |
| AUTH-003 | Shop Setup | Initialize shop details (Name, Type: Retail/Wholesale) | ✅ Verified | 2026-05-13 |
| AUTH-004 | Logout | Terminate session and return to Login screen | ✅ Verified | 2026-05-13 |
| AUTH-005 | Password Hashing | Verify passwords are encrypted in local SQLite | ✅ Verified | 2026-05-13 |

## 2. Party Management (Suppliers & Customers)
| Test Case ID | Feature | Description | Status | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| PARTY-001 | Supplier CRUD | Add, View, and List Suppliers | ✅ Verified | 2026-05-13 |
| PARTY-002 | Retailer CRUD | Add, View, and List Retailers (Customers) | ✅ Verified | 2026-05-13 |
| PARTY-003 | Customer Types | Differentiate between Big Hall, Retailer, Walk-in | ✅ Verified | 2026-05-13 |
| PARTY-004 | Balance Tracking | Real-time update of current balance after bills | ⏳ Pending | - |

## 3. Inventory & Products
| Test Case ID | Feature | Description | Status | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| INV-001 | Product CRUD | Add, Edit, and Delete products with categories | ✅ Verified | 2026-05-13 |
| INV-002 | Stock Tracking | Automatic deduction/addition on Sales/Purchase | ✅ Verified | 2026-05-13 |
| INV-003 | Low Stock Alerts | Dashboard indicator for products below threshold | ✅ Verified | 2026-05-13 |
| INV-004 | Stock Valuation | Calculation of total inventory value (Cost Price) | ✅ Verified | 2026-05-13 |

## 4. Billing & Transactions
| Test Case ID | Feature | Description | Status | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| BILL-001 | Sales Billing | Create invoice for Customer (Retailer) | ✅ Verified | 2026-05-13 |
| BILL-002 | Purchase Billing | Create stock intake bill from Supplier | ✅ Verified | 2026-05-13 |
| BILL-003 | Role Toggle | Switch between Sales/Purchase UI logic | ✅ Verified | 2026-05-13 |
| BILL-004 | PDF Export | Generate sharable PDF invoice from bill | ⏳ Pending | - |

## 5. Ledgers & Financials
| Test Case ID | Feature | Description | Status | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| LEDG-001 | Auto-Generation | Verify ledger entry creation on Bill Save | ✅ Verified | 2026-05-13 |
| LEDG-002 | Debit/Credit Logic | Supplier (Purchase) vs Retailer (Sales) signs | ✅ Verified | 2026-05-13 |
| LEDG-003 | History View | List all transactions for a specific party | ✅ Verified | 2026-05-13 |

## 6. Offline & Data Integrity
| Test Case ID | Feature | Description | Status | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| DATA-001 | Drift Persistence | Data persists after app kill and hot restart | ✅ Verified | 2026-05-13 |
| DATA-002 | UUID Generation | Client-side UUIDs for offline record creation | ✅ Verified | 2026-05-13 |
| DATA-003 | Schema Migration | Database upgrades without data loss | ✅ Verified | 2026-05-13 |

---
**Note:** This report is updated automatically after each testing cycle. Tests marked as ⏳ Pending are scheduled for the next release phase.
