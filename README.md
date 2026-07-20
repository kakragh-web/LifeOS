# LifeOS

Your AI-powered life organizer. Manage tasks, notes, calendar events, and get personalized AI assistance—all in one beautifully crafted Flutter app.

## Features

- **Smart Task Management** — Create, organize, and track tasks with priorities, categories, and due dates
- **Notes** — Capture ideas with rich note-taking, pinning, and categorization
- **Calendar** — Monthly view with agenda, event creation, and day navigation
- **AI Chat** — Personal AI life coach for contextual assistance
- **Dashboard** — Beautiful overview of your productivity at a glance
- **Dark Mode** — Full light/dark theme support
- **Cross-Platform** — iOS, Android, Web, Windows, macOS

## Tech Stack

- **Flutter** — Cross-platform UI framework
- **Riverpod** — State management
- **GoRouter** — Navigation and routing
- **Firebase** — Authentication and backend
- **Material 3** — Modern design system

## Getting Started

### Prerequisites

- Flutter SDK (3.5.2 or higher)
- Dart SDK (3.5.2 or higher)
- Firebase project configured

### Installation

1. Clone the repository:
```bash
git clone https://github.com/kakragh-web/LifeOS.git
cd LifeOS
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── firebase/
│   ├── router/
│   ├── services/
│   └── theme/
├── features/
│   ├── auth/
│   ├── calendar/
│   ├── chat/
│   ├── dashboard/
│   ├── notes/
│   ├── planner/
│   ├── settings/
│   ├── splash/
│   ├── tasks/
│   └── welcome/
└── shared/
    ├── models/
    ├── providers/
    └── widgets/
```

## Architecture

LifeOS follows Clean Architecture principles with a feature-based folder structure:

- **Domain Layer** — Entities and repository interfaces
- **Data Layer** — Repository implementations and data sources
- **Presentation Layer** — Screens, widgets, and state management

State management is handled by **Riverpod** with a clear separation between UI and business logic.

## Screenshots

> Screenshots will be added here. Placeholder list of captures to include:

| Screen | Description |
| ------ | ----------- |
| Splash | LifeOS logo with fade-in and loader |
| Welcome | Entry screen with sign-in / sign-up CTAs |
| Login | Email/password + Google sign-in |
| Register | Account creation form with validation |
| Dashboard | Feature cards grid (light & dark) |
| Tasks | Task list with priority chips and filters |
| Notes | Note cards with pinning and categories |
| Calendar | Monthly grid with event detail |
| AI Chat | Conversation with the assistant |
| Settings | Theme toggle, notifications, sign-out |

_Add images under `assets/screenshots/` and reference them above._

## Demo Video

> A 2–3 minute demo walkthrough is available here: _[insert YouTube / DevPost demo link]_

Highlights to capture: auth redirect flow, creating tasks/notes/events, asking the AI assistant
about your tasks and schedule, and toggling dark mode.

## Deployment

LifeOS targets iOS, Android, Web, Windows, macOS, and Linux from a single codebase.

### Prerequisites

- Flutter SDK **3.5.2+** and Dart SDK **3.5.2+**
- A Firebase project (required only for real authentication/backend)
- Platform toolchains: Xcode (iOS/macOS), Android SDK (Android), Visual Studio (Windows)

### 1. Firebase setup (optional but recommended)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/core/firebase/firebase_options.dart`. The committed version contains only
placeholders so the app still runs in **Preview Mode** without Firebase.

### 2. Install & run

```bash
flutter pub get
flutter run
```

### iOS

```bash
flutter build ios
# Open build/ios/Runner.xcworkspace in Xcode to archive and distribute.
```

Requirements: a valid Apple Developer signing certificate and Bundle ID.

### Android

```bash
flutter build appbundle   # upload to Google Play
# or
flutter build apk         # side-load / direct distribution
```

Signing uses `android/key.properties` + `upload-keystore.jks` (both git-ignored).

### Web

```bash
flutter build web
# Serve build/web with any static host (Firebase Hosting, Netlify, Vercel, etc.)
```

### Desktop (Windows / macOS / Linux)

```bash
flutter build windows
flutter build macos
flutter build linux
```

## Testing

```bash
flutter test      # runs the full suite (unit + widget)
flutter analyze   # static analysis / lints
```

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Flutter
- Powered by Firebase
- Designed with Material 3
