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

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Flutter
- Powered by Firebase
- Designed with Material 3
