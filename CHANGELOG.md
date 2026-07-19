# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- MIT `LICENSE`.
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and `CHANGELOG.md`.
- GitHub Actions CI workflow running `dart format`, `flutter analyze`, and
  `flutter test`.

### Changed
- `.gitignore` updated to exclude Firebase credential files and other
  sensitive/generated artifacts.

## [1.0.0] - 2026-07-19

### Added
- Smart task management with priorities, categories, and due dates.
- Notes with pinning and categorization.
- Calendar with monthly view, agenda, and event creation.
- AI chat assistant.
- Dashboard overview of productivity.
- Light and dark theme support.
- Email/password and Google Sign-In authentication via Firebase.
- Cross-platform support: iOS, Android, Web, Windows, and macOS.
- Clean Architecture structure with Riverpod state management and GoRouter
  navigation with authentication guards.

[Unreleased]: https://github.com/kakragh-web/LifeOS/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kakragh-web/LifeOS/releases/tag/v1.0.0
