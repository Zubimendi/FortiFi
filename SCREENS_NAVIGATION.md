# FortiFi - Screen Navigation Guide

## Total Screens Implemented: **8 Main Screens** + **1 Modal**

---

## 📱 Main Screens

### 1. **Onboarding Screen**
- **Route Path:** `/onboarding`
- **Route Name:** `onboarding`
- **How to Navigate:**
  - Initial screen (app starts here)
  - Or use: `context.go(RouteNames.onboarding)`
- **File:** `lib/presentation/onboarding/screens/onboarding_screen.dart`

### 2. **Security/Master Password Setup Screen**
- **Route Path:** `/master-password-setup`
- **Route Name:** `master-password-setup`
- **How to Navigate:**
  - From Onboarding: Tap "Get Started" button
  - Or use: `context.go(RouteNames.masterPasswordSetup)`
- **File:** `lib/presentation/security/screens/security_screen.dart`

### 3. **Dashboard Screen**
- **Route Path:** `/dashboard`
- **Route Name:** `dashboard`
- **How to Navigate:**
  - From Security Screen: Tap "Secure My Account" button
  - Bottom Navigation: Tap "OVERVIEW" tab (index 0)
  - Or use: `context.go(RouteNames.dashboard)`
- **File:** `lib/presentation/dashboard/screens/dashboard_screen.dart`

### 4. **New Expense Screen**
- **Route Path:** `/add-expense`
- **Route Name:** `add-expense`
- **How to Navigate:**
  - Bottom Navigation: Tap the floating "+" button in center
  - Or use: `context.push(RouteNames.addExpense)`
- **File:** `lib/presentation/expense/screens/new_expense_screen.dart`

### 5. **Insights/Analytics Screen**
- **Route Path:** `/analytics`
- **Route Name:** `analytics`
- **How to Navigate:**
  - Bottom Navigation: Tap "ANALYTICS" tab (index 2)
  - Or use: `context.go(RouteNames.analytics)`
- **File:** `lib/presentation/insights/screens/insights_screen.dart`

### 6. **Category Analysis Screen**
- **Route Path:** `/category-analysis`
- **Route Name:** `category-analysis`
- **How to Navigate:**
  - From Insights Screen: Tap "View All" button on Top Categories card
  - Or use: `context.push(RouteNames.categoryAnalysis)`
- **File:** `lib/presentation/analytics/screens/category_analysis_screen.dart`

### 7. **Settings Screen**
- **Route Path:** `/settings`
- **Route Name:** `settings`
- **How to Navigate:**
  - Bottom Navigation: Tap "MENU" tab (index 3)
  - Or use: `context.go(RouteNames.settings)`
- **File:** `lib/presentation/settings/screens/settings_screen.dart`

### 8. **Budget Screen**
- **Route Path:** `/budget`
- **Route Name:** `budget`
- **How to Navigate:**
  - Bottom Navigation: Tap "BUDGET" tab (index 1)
  - Or use: `context.go(RouteNames.budget)`
- **File:** `lib/presentation/budget/screens/budget_screen.dart`

---

## 🔲 Modal/Bottom Sheet

### 9. **Select Category Modal**
- **Not a route** - Opens as a modal bottom sheet
- **How to Navigate:**
  - From New Expense Screen: Tap "View All" button in Category Selector
  - Or call: `showModalBottomSheet()` with `SelectCategoryModal` widget
- **File:** `lib/presentation/expense/widgets/select_category_modal.dart`

---

## 🗺️ Navigation Flow

```
1. Onboarding Screen
   └─> [Get Started] ──> 2. Security Screen
                          └─> [Secure My Account] ──> 3. Dashboard Screen
                                                       ├─> [Bottom Nav: Overview] ──> Dashboard
                                                       ├─> [Bottom Nav: Budget] ──> 8. Budget Screen
                                                       ├─> [Bottom Nav: Analytics] ──> 5. Insights Screen
                                                       │   └─> [View All] ──> 6. Category Analysis Screen
                                                       ├─> [Bottom Nav: Menu] ──> 7. Settings Screen
                                                       └─> [FAB: +] ──> 4. New Expense Screen
                                                                        └─> [View All in Category] ──> 9. Select Category Modal
```

---

## 🧪 Quick Test Navigation Commands

You can test navigation programmatically using these commands in your code:

```dart
// Navigate to any screen
context.go(RouteNames.onboarding);
context.go(RouteNames.dashboard);
context.go(RouteNames.budget);
context.go(RouteNames.analytics);
context.go(RouteNames.settings);

// Push (for modals/overlays)
context.push(RouteNames.addExpense);
context.push(RouteNames.categoryAnalysis);
```

---

## 📋 Summary

- **Total Main Screens:** 8
- **Total Modals:** 1
- **Total UI Components:** 9

All screens are fully implemented with:
- ✅ Theme support (Light/Dark mode)
- ✅ Navigation integration
- ✅ Bottom navigation bar (where applicable)
- ✅ Responsive layouts
- ✅ Material Design 3 styling
