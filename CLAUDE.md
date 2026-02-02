# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KNEXATTENDANT is a valet parking attendant management app. It manages parking tickets through a state machine (Arrival → Processing → Parked → Departure → Completed), integrates with Firebase for auth/storage, and communicates with a backend API.

**Origin:** Initially created with FlutterFlow, but **now developed as standard Flutter**. We are no longer using FlutterFlow.

**Target Platforms:** iOS and Android only (no web/desktop)

## Flutter Environment

Flutter may not be in system PATH. Use the FlutterFlow Flutter installation if needed:

```bash
export PATH="$PATH:/Users/lordalexleon/Library/Application Support/io.flutterflow.prod.mac/flutter/bin"
```

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

# Clean build (fixes AssetManifest.json / google_fonts errors)
flutter clean && flutter pub get
```

## Architecture

### State Management
- **Provider** with `FFAppState` (singleton ChangeNotifier) for global state
- `AppStateNotifier` manages auth state and route redirects
- State persisted via SharedPreferences (fields prefixed with `ff_`)
- Legacy FlutterFlow patterns can be refactored to Riverpod, Bloc, etc.

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
├── flutter_flow/           # Generated utilities (theme, nav, models) - can be refactored
├── [page_name]/            # Pages with *_model.dart and *_widget.dart
├── app_constants.dart      # API endpoints
└── app_state.dart          # Global FFAppState
```

## Development Approach

This project was originally built with FlutterFlow but is now **pure Flutter**:
- Feel free to refactor FlutterFlow-generated code to standard Flutter patterns
- FlutterFlow helper classes (`FFAppState`, `FlutterFlowTheme`, etc.) can be replaced over time
- New features should use standard Flutter/Dart best practices
- No need to maintain FlutterFlow compatibility

## Common Issues & Fixes

### AssetManifest.json / google_fonts errors
```bash
flutter clean && flutter pub get
```

### FloatingNavbar overflow
Keep icon sizes at 22.0 and font sizes at 10.0 in navbar items.

### iOS Pod issues
```bash
cd ios && rm -rf Pods Podfile.lock && pod install --repo-update && cd ..
```

## Platform Requirements

- **Flutter**: 3.x stable channel
- **Dart SDK**: >=3.0.0 <4.0.0
- **iOS**: 14.0.0 minimum
- **Android**: minSdk 23, targetSdk 35

## Firebase Configuration

Project: `knex-attendant-25`
- Required: `google-services.json` in `android/app/`
- Required: `GoogleService-Info.plist` in `ios/Runner/`

## Available Tools

When working with Claude Code on this project:
- **Flutter Expert Agent** - Use `Task` tool with `subagent_type="flutter-expert"` for Flutter-specific issues and Dart debugging
