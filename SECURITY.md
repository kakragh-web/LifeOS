# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in LifeOS, please report it responsibly:

1. **DO NOT** open a public GitHub issue for security vulnerabilities.
2. Email security concerns to: **kakranimako@gmail.com**
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will acknowledge receipt within 48 hours and provide a detailed response within 7 days.

## Security Best Practices

### Firebase Configuration

This project uses Firebase for authentication and backend services. **Never commit real Firebase credentials to version control.**

Local development workflow:
1. Clone the repository
2. Run `flutterfire configure --project=YOUR_PROJECT_ID` to generate local config files
3. The following files contain real credentials and are gitignored:
   - `lib/core/firebase/firebase_options.dart`
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `android/app/src/main/res/values/google-services.xml`

### API Keys & Secrets

- Never hardcode API keys, tokens, or secrets in source code
- Use environment variables or secure credential storage
- Rotate exposed credentials immediately
- Use Firebase App Check for production security

### Dependencies

- Regularly audit dependencies: `flutter pub outdated`
- Keep Firebase SDKs up to date
- Review security advisories for all packages

### Authentication

- Firebase Authentication handles user credentials securely
- Never store passwords or tokens in SharedPreferences
- Use Firebase's built-in session management

## Known Security Considerations

1. **API Keys**: Firebase API keys are included in the repository. These keys identify the Firebase project but do not grant direct access to data. Access is controlled by Firebase Security Rules.

2. **In-Memory Storage**: Currently, tasks, notes, and calendar events are stored in-memory. This data is lost when the app closes. For production, implement Firestore with proper security rules.

3. **Google Sign-In**: Currently disabled due to platform compatibility. When enabled, ensure SHA-1/SHA-256 fingerprints are added to Firebase Console.

4. **Web Deployment**: When deploying to web, ensure Firebase App Check is enabled to prevent API abuse.

## Checklist for Production Deployment

- [ ] Enable Firebase App Check
- [ ] Configure Firestore Security Rules
- [ ] Add SHA-1/SHA-256 fingerprints for Android
- [ ] Add iOS URL Scheme for Google Sign-In
- [ ] Enable Firebase Analytics and Crashlytics
- [ ] Configure Firebase Hosting security headers
- [ ] Review and minimize app permissions
- [ ] Enable code obfuscation (`flutter build --obfuscate --split-debug-info`)
- [ ] Remove debug logging and print statements
- [ ] Implement certificate pinning for API calls
- [ ] Set up Firebase Alerts and Monitoring
