# Requirements From You — Heshab Book App

> These are things I need from your side before I can build certain parts of the app.
> **Each item is marked with which Phase it's needed for.**
> You can provide these one at a time as we reach each phase.

---

## 🔴 CRITICAL — Needed Before Phase 1 Starts

### 1. Target Platform
> Which platforms do you want to build for?

- [ ] Android only
- [ ] iOS only
- [x] Both Android + iOS

**Why needed**: Platform affects which SQLite library version and permissions to configure.

---

### 2. Flutter SDK Version
> What version of Flutter do you have installed?

Run this command and share output:
```bash
flutter --version
```

**Why needed**: Drift + Riverpod 2.x requires Flutter 3.x (SDK `^3.0.0`). Need to confirm compatibility.

---

### 3. App Name & App ID (Bundle ID)
> What should be the official app name shown on phone?

- **App Name**: (e.g., "Heshab Book" or "हिसाब Book")
- **Android Package ID**: (e.g., `com.yourname.heshabbook`)
- **iOS Bundle ID**: (e.g., `com.yourname.heshabbook`)

**Why needed**: Required for Android `AndroidManifest.xml` and iOS `Info.plist` configuration.

---

### 4. App Language
> What language should the UI be in?

- [ ] English only
- [ ] Hindi only
- [x] Both (Hindi + English toggle)
- [x] Gujarati
- [ ] Other: ___________

**Why needed**: Determines if we need `flutter_localizations` and whether to build multi-language from start.

---

## 🟡 Needed Before Phase 3 — Authentication

### 5. Authentication Type
> How will users log in?

- [x] Local only (no internet, just password on device)
- [ ] Mobile OTP (requires Firebase or SMS service)
- [x] Email + Password (local only)
- [x] Email + Password (with cloud backend)
- [ ] No login at all (single user, open app directly)

**Why needed**: Determines if we use Firebase Auth or local SQLite-based auth.

---

### 6. Multi-User on Same Device?
> Can multiple users (shop owners) use the same phone?

- [x] Yes — need login/logout and account switcher
- [ ] No — single owner, single device

---

## 🟡 Needed Before Phase 4 — Shop Setup

### 7. Shop Types
> What shop types should be supported?

Default options from README:
- Big Hall Seller (Wholesale Supplier)
- Mix Hall Seller + Retail
- Retail Only Shop

- [x] These 3 are enough
- [x] I want to add more: ___________
- [x] Let user create custom shop type

---

### 8. GST Support
> Do you need GST billing?

- [x] No — plain billing without GST
- [x] Yes — CGST + SGST + IGST support
- [x] Yes but optional per bill

**Why needed**: GST completely changes the bill calculation and table structure.

---

## 🟡 Needed Before Phase 10 — Billing

### 9. Bill Number Format
> How should bill numbers look?

Examples:
- `BILL-0001`
- `PB-2025-001` (Purchase Bill)
- `SB-2025-001` (Sales Bill)
- Custom: ___________

---

### 10. Currency & Number Format
> What currency and number format?

- **Currency Symbol**: (e.g., ₹)
- **Number Format**: (e.g., Indian: `1,00,000` or International: `100,000`)
- **Decimal Places**: (e.g., 2)
Indian: `1,00,000`
---

## 🔵 Needed Before Phase 16 — Reports

### 11. PDF / Print Support
> Do you want PDF invoice generation?

- [x] Yes — PDF invoice for bills
- [x] Yes — also WhatsApp share
- [ ] No — not needed now

---

### 12. Excel Export
> Do you want Excel export for reports?

- [x] Yes
- [ ] No

---

## 🔵 Future — Cloud Sync (Phase 18)

### 13. Backend Preference (For Future Sync)
> If you want cloud sync in future, which backend?

- [ ] Firebase (easiest)
- [ ] Custom REST API
- [ ] Supabase
- [x] Not decided yet

---

## ✅ Provided Information

| # | Item | Status | Value |
|---|------|--------|-------|
| 1 | Target Platform | ⬜ | - |
| 2 | Flutter Version | ⬜ | - |
| 3 | App Name & Bundle ID | ⬜ | - |
| 4 | App Language | ⬜ | - |
| 5 | Auth Type | ⬜ | - |
| 6 | Multi-User | ⬜ | - |
| 7 | Shop Types | ⬜ | - |
| 8 | GST Support | ⬜ | - |
| 9 | Bill Number Format | ⬜ | - |
| 10 | Currency Format | ⬜ | - |
| 11 | PDF Support | ⬜ | - |
| 12 | Excel Export | ⬜ | - |
| 13 | Backend (Future) | ⬜ | - |

---

> 📌 **Action**: Please answer at minimum items **1, 2, 3, 4, 5** so Phase 1 can begin.
> The rest can be answered later as we reach those phases.
