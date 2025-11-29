# KNEX Attendant - Flutter Project

## Project Overview
This is a valet/parking attendant management app. The app handles ticket creation, status tracking, and attendant workflows.

**Origin:** Initially created with FlutterFlow, but **now developed as standard Flutter**. We are no longer using FlutterFlow.

**Target Platforms:** iOS and Android only (no web/desktop)

## Flutter Environment

Flutter is NOT in the system PATH. Use the FlutterFlow Flutter installation:

```bash
# Set PATH for current session
export PATH="$PATH:/Users/lordalexleon/Library/Application Support/io.flutterflow.prod.mac/flutter/bin"

# Or use full path directly
"/Users/lordalexleon/Library/Application Support/io.flutterflow.prod.mac/flutter/bin/flutter" <command>
```

## Common Commands

```bash
# Clean build cache (fixes AssetManifest.json errors)
flutter clean && flutter pub get

# Run on iOS device
flutter run

# Build iOS
flutter build ios

# Build Android
flutter build apk
```

## Code Style & Conventions

- **Standard Flutter development** - FlutterFlow patterns can be refactored as needed
- Use 2-space indentation (Dart standard)
- Components are in `lib/components/`
- Custom actions are in `lib/custom_code/`
- Utility functions are in `lib/flutter_flow/` (legacy, can be refactored)

## Development Approach

This project was originally built with FlutterFlow but is now **pure Flutter**:
- Feel free to refactor FlutterFlow-generated code to standard Flutter patterns
- FlutterFlow helper classes (`FFAppState`, `FlutterFlowTheme`, etc.) can be replaced with standard solutions over time
- New features should use standard Flutter/Dart best practices
- No need to maintain FlutterFlow compatibility

## Architecture

- **State Management:** Provider + FFAppState (legacy - can migrate to Riverpod, Bloc, or other)
- **Navigation:** GoRouter (`lib/flutter_flow/nav/`)
- **Authentication:** Firebase Auth (`lib/auth/firebase_auth/`)
- **API Communication:** Custom HTTP functions in `lib/custom_code/actions/`
- **Theme:** FlutterFlowTheme (legacy - can migrate to standard ThemeData)

## API Endpoints

Base URL: `https://api.knex-app.xyz/api/`

- `getTicketList` - Fetch tickets by status
- `getUser` - Get user profile
- `setStatus` - Update ticket status
- `creaTicket` - Create new ticket

## Key Files

- `lib/main.dart` - App entry point and NavBar
- `lib/app_state.dart` - Global app state (FFAppState)
- `lib/app_constants.dart` - App constants and configuration
- `lib/index.dart` - Page exports

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

## Available Tools

When working with Claude Code on this project:

1. **Context7 MCP** - Use `mcp__context7__resolve-library-id` and `mcp__context7__get-library-docs` to fetch up-to-date Flutter/Dart documentation
2. **Flutter Expert Agent** - Use `Task` tool with `subagent_type="flutter-expert"` for Flutter-specific issues, FlutterFlow integration, and Dart debugging

## Security Notes

- Never commit Firebase credentials or API keys
- The `firebase/` directory contains Firebase configuration - handle with care
- JWT tokens are used for API authentication
