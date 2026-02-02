# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KNEXATTENDANT is a FlutterFlow-based mobile app for valet parking attendants. It manages parking tickets through a state machine (Arrival → Processing → Parked → Departure → Completed), integrates with Firebase for auth/storage, and communicates with a backend API at `knex-app.xyz`.

## Build Commands

```bash
# Install dependencies
flutter pub get

# iOS dependencies (required after dependency changes)
cd ios && pod install && cd ..

# Run app
flutter run

# Build for release
flutter build apk --release      # Android APK
flutter build appbundle --release # Android App Bundle
flutter build ios --release      # iOS
```

## Architecture

### FlutterFlow Model-View Pattern
Every page and component uses dual files:
- `*_widget.dart` - StatefulWidget UI (largely FlutterFlow-generated)
- `*_model.dart` - `FlutterFlowModel` subclass managing state and lifecycle

### State Management
- **Provider** with `FFAppState` (singleton ChangeNotifier) for global state
- `AppStateNotifier` manages auth state and route redirects
- State persisted via SharedPreferences (fields prefixed with `ff_`)

### Navigation
- **GoRouter** with routes defined in `lib/flutter_flow/nav/nav.dart`
- `NavBarPage` wraps bottom navigation with 4 tabs (Home, Profile, Chat, QR)
- Auth guards check `AppStateNotifier.loggedIn`

### Authentication
Multi-provider Firebase auth in `lib/auth/firebase_auth/`:
- Email, Google, Apple, Anonymous, JWT, GitHub, Phone
- Access current user: `currentUserEmail`, `currentUserUid`, `currentJwtToken`
- JWT refreshes hourly via `jwtTokenStream`

### API Integration
All endpoints defined in `lib/app_constants.dart` (base: `https://www.knex-app.xyz/api/`)
- Requests authenticated with JWT token in `idToken` field
- Custom actions in `lib/custom_code/actions/` handle API calls with retry logic

## Key Directories

```
lib/
├── auth/firebase_auth/     # Auth provider implementations
├── backend/firebase/       # Firebase config
├── components/             # Reusable widgets (slidables, bottom sheets)
├── custom_code/actions/    # Custom async functions (API calls, utilities)
├── flutter_flow/           # Generated utilities (theme, nav, models)
├── [page_name]/            # Pages with *_model.dart and *_widget.dart
├── app_constants.dart      # API endpoints
└── app_state.dart          # Global FFAppState
```

## FlutterFlow Conventions

**Safe to edit:**
- Custom actions in `lib/custom_code/actions/`
- Custom functions in `lib/flutter_flow/custom_functions.dart`
- Business logic in `*_model.dart` files

**Avoid editing directly:**
- FlutterFlow-generated UI code in `*_widget.dart`
- Navigation routes (modify via FlutterFlow)
- Theme configuration

## Custom Actions Pattern

Custom actions follow this structure (see `lib/custom_code/actions/crea_ticket.dart`):
```dart
Future<String> actionName(String param1, String param2) async {
  // Input validation with InputValidator
  // HTTP request with retry logic (max 3 retries)
  // JWT auth via currentJwtToken
  // Return JSON string response
}
```

## Platform Requirements

- **Flutter**: 3.x stable channel
- **Dart SDK**: >=3.0.0 <4.0.0
- **iOS**: 14.0.0 minimum (Podfile)
- **Android**: minSdk 23, targetSdk 35

## Firebase Configuration

Project: `knex-attendant-25`
- Required: `google-services.json` in `android/app/`
- Required: `GoogleService-Info.plist` in `ios/Runner/`
