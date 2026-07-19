# Contributing to LifeOS

Thank you for your interest in contributing to LifeOS! We welcome contributions
of all kinds — bug fixes, new features, documentation improvements, and more.

## Code of Conduct

This project and everyone participating in it is governed by our
[Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to
uphold this code.

## Getting Started

1. **Fork** the repository and clone your fork:
   ```bash
   git clone https://github.com/<your-username>/LifeOS.git
   cd LifeOS
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (required to run the full app):
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   > Never commit real Firebase credentials. The committed
   > `firebase_options.dart`, `google-services.json`, and
   > `GoogleService-Info.plist` contain placeholder values only.

4. **Run the app**:
   ```bash
   flutter run
   ```

## Development Workflow

1. Create a feature branch from `master`:
   ```bash
   git checkout -b feature/my-feature
   ```

2. Make your changes, following the coding standards below.

3. Ensure all checks pass locally before pushing:
   ```bash
   dart format --output=none --set-exit-if-changed .
   flutter analyze
   flutter test
   ```

4. Commit with a clear, descriptive message.

5. Push your branch and open a Pull Request against `master`.

## Coding Standards

- Follow the [effective Dart](https://dart.dev/effective-dart) style guide.
- The project uses `flutter_lints` plus custom rules defined in
  `analysis_options.yaml`. Run `flutter analyze` and fix all warnings.
- Format code with `dart format .` before committing.
- Prefer single quotes and package imports (enforced by lint rules).
- Follow the existing Clean Architecture structure:
  - **Domain** — entities and repository interfaces
  - **Data** — repository implementations
  - **Presentation** — screens, widgets, and state management
- Add or update tests for any behavior you change.

## Pull Request Guidelines

- Keep PRs focused and reasonably small.
- Reference any related issues in the PR description.
- Ensure CI is green (analyze, test, and format checks).
- Describe what changed and why.

## Reporting Bugs

Open an issue with:
- A clear, descriptive title.
- Steps to reproduce.
- Expected vs. actual behavior.
- Environment details (OS, Flutter version, device/platform).

## Suggesting Features

Open an issue describing the feature, the problem it solves, and any
alternatives you considered.

## Security

If you discover a security vulnerability, please **do not** open a public
issue. Instead, report it privately to the maintainers so it can be addressed
responsibly.

Thank you for helping make LifeOS better!
