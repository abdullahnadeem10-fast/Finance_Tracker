# LuxeVault - Technical Implementation Plan

## Summary
LuxeVault is a high-end, production-ready Android Finance Tracker built with Flutter and Firebase. It employs a Feature-First architecture with Riverpod for state management. The UI leans heavily on Material 3, Dark Mode, glassmorphism effects, and `fl_chart` for data visualization. This plan outlines the technical roadmap, expanded project structure, Firebase database schema, and initial setup steps required to build the application.

---

## 1. Technical Roadmap

### Phase 1: Setup & Architecture (Days 1-2)
*   **Project Initialization**: Initialize the Flutter project, clean up boilerplate, configure for Android.
*   **Dependencies**: Add Riverpod, Firebase, `fl_chart`, Google Sign-In, and styling packages (glassmorphism).
*   **Folder Structure**: Scaffold the Feature-First directory structure.
*   **Theming**: Set up Material 3 theme data, particularly tuning the Dark Mode and defining glassmorphic utility widgets. 

### Phase 2: Authentication & User Management (Days 3-5)
*   **Firebase Config**: Configure Firebase project, enable Auth (Email/Password, Google).
*   **Auth Feature**: Build UI for Login, Sign Up, and Forgot Password.
*   **State Management**: Implement Riverpod providers for Auth state.
*   **User Provisioning**: Save user profiles to Firestore upon successful registration.

### Phase 3: Core Features - Transactions & Budgets (Days 6-12)
*   **Backend Services**: Create Firestore repository classes for transactions and budgets.
*   **Transaction Management**: 
    *   UI to Add/Edit/Delete expenses and incomes.
    *   Firebase Storage integration for attaching receipt images.
*   **Dashboard**: 
    *   Implement `fl_chart` for income vs expense visualization.
    *   Recent transactions list.

### Phase 4: Polish & Production Readiness (Days 13-15)
*   **Settings & Profile**: Theme toggle, profile updates, logout functionality.
*   **Error Handling**: Global error boundaries and user-friendly snackbars.
*   **Performance & Security**: Setup Firestore security rules, test image caching, optimize build sizes.
*   **Release**: Build Android App Bundle (AAB), setup Proguard, final QA logging.

---

## 2. Elaborated Folder Structure (Feature-First)

```text
lib/
 ├── core/
 │    ├── constants/       # App colors, text styles, API keys
 │    ├── theme/           # AppTheme, dark/light mode definitions
 │    ├── utils/           # Helper functions, formatters (currency, dates)
 │    └── widgets/         # Shared UI components (Glassmorphism containers, custom buttons)
 ├── features/
 │    ├── auth/
 │    │    ├── domain/     # Models (UserEntity)
 │    │    ├── data/       # Repositories (AuthRepository)
 │    │    ├── providers/  # Riverpod controllers (auth_controller.dart)
 │    │    └── presentation/ # Screens (login_screen.dart, signup_screen.dart)
 │    ├── dashboard/
 │    │    ├── providers/  
 │    │    └── presentation/ # dashboard_screen.dart, widgets/expense_chart.dart
 │    ├── transactions/
 │    │    ├── domain/     # Models (TransactionModel)
 │    │    ├── providers/  
 │    │    └── presentation/ # add_transaction_screen.dart, transaction_list.dart
 │    └── settings/
 │         ├── providers/
 │         └── presentation/ # profile_screen.dart, settings_screen.dart
 ├── services/
 │    ├── firebase_service.dart   # Firebase initialization
 │    ├── storage_service.dart    # Receipt image uploads
 │    └── local_storage.dart      # SharedPreferences for local theme prefs
 └── main.dart             # Entry point, Riverpod ProviderScope, App routing
```

---

## 3. Firebase Schema (Firestore)

### Collection: `users`
*   **UID**: `documentId` (matches Firebase Auth UID)
    *   `email`: string
    *   `displayName`: string
    *   `photoUrl`: string (optional)
    *   `createdAt`: timestamp
    *   `currencyPreference`: string (e.g., "USD")

### Collection: `users/{userId}/transactions` (Subcollection)
*   **Document ID**: auto-generated
    *   `amount`: number (double)
    *   `type`: string ("income" | "expense")
    *   `category`: string (e.g., "Food", "Transport")
    *   `title`: string
    *   `date`: timestamp
    *   `receiptImageUrl`: string (optional, from Firebase Storage)
    *   `notes`: string (optional)

### Collection: `users/{userId}/budgets` (Subcollection)
*   **Document ID**: auto-generated `categoryId` (or specific month string like "2026-03")
    *   `category`: string
    *   `monthlyLimit`: number (double)
    *   `spentSoFar`: number (double)
    *   `alertsEnabled`: boolean

---

## 4. Initial Setup Phase

1. **Install Firebase CLI and FlutterFire CLI**:
   Ensure `flutterfire_cli` is active globally.
2. **Initialize Firebase**:
   Run `flutterfire configure` to link the Dart project to the target Firebase project.
3. **Add Pub.dev Dependencies**:
   Update `pubspec.yaml` with:
   *   `flutter_riverpod`
   *   `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
   *   `google_sign_in`
   *   `fl_chart`
   *   `glassmorphism` (or similar packages)
   *   `intl` (for currency/date formatting)
4. **Scaffold Architecture**:
   Create the directory structure inside `lib/` as outlined above. Empty placeholder files can be used to set up exports.
5. **Main & Theme Setup**:
   Wrap `runApp` with `ProviderScope`. Set up the baseline `MaterialApp` with the Material 3 Dark theme inside `core/theme/`.

## Edge Cases to Handle
*   Offline state: Firestore handles offline caching by default, but UI needs to reflect sync status or warn if receipt images are waiting to upload.
*   Graph rendering on zero data: `fl_chart` can crash or look broken if fed empty data. Implement a fallback zero-state UI.
*   Image permissions: Requesting gallery/camera access properly on newer Android OS versions (Android 13+).

## Open Questions
*   Will the client allow manual transaction entry only, or is Bank API integration (e.g., Plaid) planned for the future?
*   Should receipt images be compressed before uploading to save Firebase Storage costs? (Highly recommended to add `flutter_image_compress`).
