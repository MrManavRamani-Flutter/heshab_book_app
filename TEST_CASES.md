# 🧪 Heshab Book — Quality Assurance & Test Verification

> **Verification Date**: 2026-10-09  
> **Status**: 🟢 **ALL CORE TESTS PASSING**

---

## 📋 Test Matrix

| Test Suite | Case ID | Description | Expected Behavior | Status |
|---|---|---|---|---|
| **Database** | `DB-001` | SQLite Persistence | App restart retains all products, parties, orders, and payments | ✅ PASS |
| **Database** | `DB-002` | Foreign Key Constraints | Deleting an order cascades and cleans up line items properly | ✅ PASS |
| **Parties** | `PTY-001` | Add Customer & Wholesale Party | Party saved with name, language translations, and phone number | ✅ PASS |
| **Parties** | `PTY-002` | Search & Filter | Localized real-time filtering matches English, Hindi, and Gujarati | ✅ PASS |
| **Parties** | `PTY-003` | Balance Calculation | Total bills minus received payments equals net pending amount | ✅ PASS |
| **Products** | `PRD-001` | Add / Edit Product | Name, price, stock saved without form race-conditions | ✅ PASS |
| **Products** | `PRD-002` | Stock Adjustment | Purchase bill adds stock; Sales bill deducts stock instantly | ✅ PASS |
| **Billing** | `BIL-001` | Sales Order Creation | Adding items calculates subtotal, bill total, and saves successfully | ✅ PASS |
| **Billing** | `BIL-002` | Purchase Order Intake | Supplier purchase order saves and updates supplier pending total | ✅ PASS |
| **Payments** | `PAY-001` | Partial Payment Entry | Payment reduces order pending balance and updates overall ledger | ✅ PASS |
| **Reminders**| `REM-001` | Local Notification Schedule | Reminder triggers OS alert when overdue days threshold is reached | ✅ PASS |
| **UI / UX** | `UI-001` | Localization Switch | Dynamic change between English, Hindi, and Gujarati without app restart | ✅ PASS |
| **UI / UX** | `UI-002` | Theme Switch | Light and Dark modes render with correct high-contrast palette | ✅ PASS |
| **Branding** | `BRD-001` | Launcher Icons & Splash | Custom 3D Khata icon appears on home screen and native launch splash | ✅ PASS |
