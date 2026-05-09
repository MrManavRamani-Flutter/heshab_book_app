# Heshab Book App — Error & Fix Log

> This file tracks ALL errors encountered during development, their root cause, and the fix applied.
> **Purpose**: Never repeat the same mistake. Always reference this before writing similar code.
> **Last Updated**: 2026-05-09

---

## Error Log Format

Each entry follows this format:

```
### ERR-XXX — [Short Title]
- **Phase**: Which phase
- **Date**: When encountered
- **File(s)**: Which file(s) affected
- **Error Message**: Exact error
- **Root Cause**: Why it happened
- **Fix Applied**: What was done
- **Prevention Rule**: Rule to follow going forward
```

---

## ⚠️ Rules Derived From Past Experience (Pre-populated)

These rules are based on general Flutter/Drift/Riverpod production patterns.
**Always check these FIRST before writing new code.**

---

### RULE-001 — UUID Always Required
- **Context**: Database design
- **Rule**: Every table MUST have both `id` (auto-increment) AND `uuid` (String, UUID v4)
- **Reason**: Auto-increment IDs break future cloud sync. UUIDs are stable across devices.
- **Violation Result**: Sync system cannot work, data conflicts on merge

---

### RULE-002 — Never Directly Edit Stock
- **Context**: Stock Management
- **Rule**: NEVER update `products.current_stock` directly.
- **Always Do**: Create a `stock_transactions` record. The stock is derived from transactions.
- **Violation Result**: No audit trail, broken profit tracking, data inconsistency

---

### RULE-003 — Soft Delete Only
- **Context**: All database tables
- **Rule**: NEVER hard-delete any record. Always set `is_deleted = true` and `deleted_at = now`.
- **Reason**: Billing history must stay intact. Linked ledger/payment records must remain valid.
- **Violation Result**: Foreign key errors, broken reports, missing history

---

### RULE-004 — Every Table Must Have 6 Base Fields
- **Context**: Drift table design
- **Required Fields**:
  - `id` (IntColumn, autoIncrement)
  - `uuid` (TextColumn, unique, not null)
  - `created_at` (DateTimeColumn)
  - `updated_at` (DateTimeColumn)
  - `deleted_at` (DateTimeColumn, nullable)
  - `is_deleted` (BoolColumn, default false)
  - `sync_status` (TextColumn, default 'pending')

---

### RULE-005 — Shop Scoped Data
- **Context**: All feature data
- **Rule**: Every data entity (Product, Supplier, Bill, etc.) MUST have a `shop_id` foreign key.
- **Reason**: One user can have multiple shops. Data must be isolated per shop.
- **Violation Result**: Data from one shop leaks into another

---

### RULE-006 — Build Runner Must Be Run After Model Changes
- **Context**: Freezed / Drift / Riverpod code gen
- **Rule**: After changing any `.dart` file with `@freezed`, `@DriftAccessor`, or `@riverpod` annotation, always run:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- **Violation Result**: Stale generated files cause type errors and runtime crashes

---

### RULE-007 — Ledger Always Auto-Created
- **Context**: Billing + Payment
- **Rule**: When a Bill is saved OR a Payment is recorded, a `ledger` entry MUST be automatically created. Never rely on user to manually create ledger entries.
- **Violation Result**: Ledger becomes inconsistent, balances wrong

---

### RULE-008 — Pending Amount Is Always Calculated, Never Stored Directly
- **Context**: Billing
- **Rule**: `pending_amount = total_amount - paid_amount`. This should be a computed value. If stored, it must always be recalculated and synced whenever a payment is made.
- **Violation Result**: Pending amounts drift out of sync

---

### RULE-009 — Riverpod StateNotifier vs AsyncNotifier
- **Context**: State Management
- **Rule**: Use `AsyncNotifier` (Riverpod 2.x) for async data. Use `Notifier` for sync state.
- **Never use**: `ChangeNotifier`, `StateNotifier` (deprecated in Riverpod 2)
- **Violation Result**: Deprecation warnings, future breaking changes

---

### RULE-010 — GoRouter Auth Guard
- **Context**: Routing
- **Rule**: GoRouter redirect must check auth state BEFORE allowing access to any protected route.
- **Violation Result**: Unauthenticated users can access app data

---

## 🐛 Active Error Log

*No errors logged yet. Errors will be added here as development progresses.*

---

## ✅ Resolved Errors

### ERR-001 — Duplicate Route Definition
- **Phase**: Phase 3 — Authentication Module
- **Date**: 2026-05-09
- **File(s)**: `lib/config/routes/route_names.dart`
- **Error Message**:
  ```
  error • The name 'shopSetup' is already defined • lib/config/routes/route_names.dart:32:23 • duplicate_definition
  ```
- **Root Cause**: Manually added the same constant twice while organizing route groups (Auth vs Settings).
- **Fix Applied**: Removed the duplicate definition at the end of the file.
- **Prevention Rule**: Always check for existing constants before adding new ones, or use a tool to sort/deduplicate constants.

---

### ERR-002 — Undefined Drift Companions
- **Phase**: Phase 3 — Authentication Module
- **Date**: 2026-05-09
- **File(s)**: `lib/features/auth/data/repositories/auth_repository.dart`, `lib/features/auth/presentation/screens/shop_setup_screen.dart`
- **Error Message**:
  ```
  error • Undefined name 'UsersCompanion' • lib/features/auth/data/repositories/auth_repository.dart:97:7 • undefined_identifier
  error • Undefined name 'ShopsCompanion' • lib/features/auth/presentation/screens/shop_setup_screen.dart:88:9 • undefined_identifier
  ```
- **Root Cause**: Drift generates companion classes in the `.g.dart` file of the database. Importing only the table definition file is not enough to access companions in other layers.
- **Fix Applied**: Imported `package:heshab_book_app/database/app_database.dart` which exports the necessary generated types.
- **Prevention Rule**: Always import the main database file when working with Drift companions in repositories or screens.

---

### ERR-003 — Unnecessary Underscores in Ref.listen
- **Phase**: Phase 3 — Authentication Module
- **Date**: 2026-05-09
- **File(s)**: `lib/config/routes/app_router.dart`
- **Error Message**:
  ```
  info • Unnecessary use of multiple underscores • lib/config/routes/app_router.dart:24:46 • unnecessary_underscores
  ```
- **Root Cause**: Used `(_, __)` in a callback where the analyzer expects only one underscore or descriptive names if there are multiple arguments.
- **Fix Applied**: Changed `(_, __)` to `(prev, next)`.
- **Prevention Rule**: Follow Dart lint rules for private/unused variables. Use descriptive names like `(p, n)` or `(prev, next)` for riverpod listeners.


---

## 📋 Error Entry Template

Copy this for each new error:

```markdown
### ERR-001 — [Short descriptive title]
- **Phase**: Phase X — [Phase Name]
- **Date**: YYYY-MM-DD
- **File(s)**: `lib/path/to/file.dart`
- **Error Message**:
  ```
  [Paste exact error here]
  ```
- **Root Cause**: [Why it happened — be specific]
- **Fix Applied**: [Exact code change or command run]
- **Prevention Rule**: [What rule to add or follow in future]
- **Status**: ✅ Resolved
```
