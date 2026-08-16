# LifeOS

Your AI-powered life organizer. Manage tasks, notes, calendar events, and get personalized AI assistance—all in one beautifully crafted Flutter app.

## Features

- **Smart Task Management** — Create, organize, and track tasks with priorities, categories, and due dates
- **Notes** — Capture ideas with rich note-taking, pinning, and categorization
- **Calendar** — Monthly view with agenda, event creation, and day navigation
- **AI Chat** — Personal AI life coach for contextual assistance
- **Dashboard** — Beautiful overview of your productivity at a glance
- **Dark Mode** — Full light/dark theme support with Material 3
- **Cross-Platform** — iOS, Android, Web, Windows, macOS

## Tech Stack

- **Flutter** — Cross-platform UI framework
- **Riverpod** — State management
- **GoRouter** — Navigation and routing
- **Firebase** — Authentication and backend
- **Material 3** — Modern design system with solid surfaces

## Design System

LifeOS features a unified design system built on Material 3:

- **AppColors** — Consistent color palette with semantic colors
- **AppTypography** — Premium typography scale
- **AppSpacing** — 4pt grid spacing system
- **AppRadius** — Border radius tokens
- **AppShadows** — Layered shadow system
- **ResponsiveShell** — Adaptive layout for mobile, tablet, and desktop
- **AnimatedButton** — Button with press feedback
- **AnimatedTextField** — Text field with focus animations
- **AppDialog** — Material 3 dialog
- **StatusChip** — Status indicator chips
- **AppAvatar** — Avatar with initials fallback

## Getting Started

### Prerequisites

- Flutter SDK (3.19.0 or higher)
- Dart SDK (3.3.0 or higher)
- Firebase project configured (optional for preview mode)
- Git, GitHub CLI (`gh`), and Vercel CLI (for deployment)

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

3. Configure Firebase (optional):
```bash
# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure --project=your-project-id
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/           # App constants and routes
│   ├── router/              # GoRouter configuration
│   ├── services/            # Storage and other services
│   └── theme/               # Design system (colors, typography, spacing, widgets)
├── features/
│   ├── auth/                # Authentication (login, register)
│   ├── calendar/            # Calendar screen and providers
│   ├── chat/                # AI chat interface
│   ├── dashboard/           # Home dashboard
│   ├── notes/               # Notes management
│   ├── planner/             # Daily planner
│   ├── settings/            # App settings
│   ├── splash/              # Splash screen
│   ├── tasks/               # Task management
│   └── welcome/             # Welcome/onboarding
└── shared/
    ├── providers/           # Shared Riverpod providers
    └── widgets/             # Reusable UI components
```

## Architecture

LifeOS follows Clean Architecture principles with a feature-based folder structure:

- **Domain Layer** — Entities and repository interfaces
- **Data Layer** — Repository implementations and data sources
- **Presentation Layer** — Screens, widgets, and state management

State management is handled by **Riverpod** with a clear separation between UI and business logic.

## CLI Tools

### Firebase CLI
```bash
# Install
npm install -g firebase-tools

# Login
firebase login

# Initialize project
firebase init
```

### FlutterFire CLI
```bash
# Activate
dart pub global activate flutterfire_cli

# Configure
flutterfire configure --project=your-project-id
```

### GitHub CLI
```bash
# Install
brew install gh

# Login
gh auth login

# Common commands
gh repo view
gh issue list
gh pr create
```

### Vercel CLI
```bash
# Install
npm install -g vercel

# Login
vercel login

# Deploy
vercel --prod
```

## Development

### Linting
```bash
flutter analyze
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Formatting
```bash
# Format code
dart format lib/ test/

# Check formatting
dart format lib/ test/ --set-exit-if-changed
```

## Deployment

### Web (Vercel)
```bash
# Build web
flutter build web --release

# Deploy with Vercel
vercel --prod
```

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS
flutter build ios --release

# Open in Xcode for archiving
open build/ios/Runner.xcworkspace
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Flutter
- Powered by Firebase
- Designed with Material 3
