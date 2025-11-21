# KNEXATTENDANT

A Flutter-based mobile application for parking attendants to manage valet parking operations, built with FlutterFlow.

## Overview

KNEXATTENDANT is a comprehensive parking management application designed for valet attendants. It provides tools to track vehicles, manage tickets, handle parking operations, and communicate with customers through an intuitive mobile interface.

## Features

- **Authentication**: Multi-provider authentication (Email, Google, Apple, Anonymous)
- **Ticket Management**: Create, track, and manage parking tickets through different states (arrival, processing, parked, departure, completed)
- **QR Code Support**: Generate and scan QR codes for quick ticket access
- **Real-time Chat**: Communicate with customers through an integrated chat system
- **Payment Processing**: Handle payment transactions via integrated payment forms
- **Profile Management**: User profile customization and settings
- **Firebase Integration**: Backend powered by Firebase (Auth, Storage, Firestore, Performance)
- **Media Support**: Image and video handling for documentation

## Tech Stack

- **Framework**: Flutter 3.x (Dart SDK >=3.0.0 <4.0.0)
- **Backend**: Firebase (Auth, Firestore, Storage, Performance)
- **State Management**: Provider
- **Navigation**: GoRouter
- **UI Components**:
  - Material Design & Cupertino widgets
  - Custom animations with flutter_animate
  - Floating bottom navigation bar
  - Photo viewing with zoom support
  - Barcode generation

## Project Structure

```
lib/
├── auth/                    # Authentication logic
│   └── firebase_auth/      # Firebase auth implementations
├── backend/                # Backend integrations
│   └── firebase/           # Firebase configuration
├── components/             # Reusable UI components
│   ├── slidables/         # Slidable ticket list items
│   └── bottom_sheets/     # Bottom sheet components
├── custom_code/           # Custom actions and functions
├── flutter_flow/          # FlutterFlow generated utilities
├── pages/                 # Application pages
│   ├── login_page/
│   ├── home_page/
│   ├── ticket_list/
│   ├── ticket/
│   ├── chat_page/
│   ├── q_r_code/
│   └── profile/
├── main.dart              # App entry point
└── app_state.dart         # Global app state
```

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK >=3.0.0 <4.0.0
- Firebase project setup
- iOS: Xcode and CocoaPods
- Android: Android Studio

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd new_attendant
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`
   - Update Firebase configuration in `lib/backend/firebase/firebase_config.dart`

4. Install iOS dependencies:
   ```bash
   cd ios && pod install && cd ..
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Platform Support

- iOS
- Android
- Web (partial support)

## Firebase Services Used

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Performance Monitoring

## Key Dependencies

- `firebase_core`, `firebase_auth`, `firebase_storage` - Firebase integration
- `go_router` - Navigation
- `provider` - State management
- `google_sign_in`, `sign_in_with_apple` - Social authentication
- `cached_network_image` - Image caching
- `barcode_widget` - QR code generation
- `image_picker` - Camera/gallery access
- `shared_preferences` - Local storage
- `lottie` - Animations

## Development

This is a FlutterFlow project. For best results:
- Build on Flutter stable channel
- Use FlutterFlow for UI modifications
- Custom code in `lib/custom_code/`
- Main application logic in page models

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Version

Current version: 1.0.0+1

## License

Private project - not for public distribution
