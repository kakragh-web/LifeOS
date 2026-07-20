# LifeOS — Your AI-Powered Life Organizer

> One app to plan your day, capture your thoughts, and get AI guidance — beautifully crafted with Flutter.

## 🏆 Tagline

**LifeOS: Plan. Capture. Achieve. — an AI-powered life organizer that turns chaos into a calm, connected daily routine.**

---

## 📌 Problem Statement

Modern life is fragmented across dozens of disconnected apps: one for tasks, another for notes,
a calendar here, a chatbot there. People constantly context-switch, lose track of priorities, and
never get a single, coherent view of *what to do next*. Worse, most tools are passive — they store
information but never help you act on it.

LifeOS solves this by unifying **tasks, notes, calendar, and an AI assistant** into one seamless,
good-looking workspace. Instead of managing four apps, you manage one life.

---

## 💡 Solution Overview

LifeOS is a cross-platform Flutter application that brings everyday productivity surfaces together
behind a single, adaptive Material 3 interface. A central dashboard gives an at-a-glance overview,
while each feature (Tasks, Notes, Calendar, AI Chat) is a focused, fast screen. An AI assistant
understands the context of your tasks, schedule, and notes and offers proactive, personalized help.

Key design goals:
- **Unified** — everything lives in one app, one navigation model.
- **Adaptive** — phone, tablet, and desktop layouts from a single codebase.
- **Resilient** — runs in a "Preview Mode" even before Firebase is configured, so it always demos.
- **Tested** — 82 automated tests covering repositories, providers, routing, and every screen.

---

## ✨ Key Features

- **Smart Task Management** — create, filter, and track tasks by priority, status, category, and due date.
- **Notes** — capture ideas with pinning and categorization; search across all notes.
- **Calendar** — monthly grid with day detail, event creation, and smooth month navigation.
- **AI Chat** — a contextual AI life coach that responds to questions about tasks, schedule, and notes.
- **Dashboard** — a beautiful feature overview with quick navigation to every module.
- **Authentication** — email/password and Google sign-in (Firebase), with a stub fallback for previews.
- **Dark Mode** — full light/dark theme support, persisted across sessions.
- **Cross-Platform** — iOS, Android, Web, Windows, macOS, and Linux from one codebase.

---

## 🛠 Technical Highlights

- **Flutter 3.5** with **Material 3** design system and adaptive, responsive layouts.
- **Riverpod** for predictable, testable state management (notifiers, stream providers).
- **GoRouter** for declarative routing with auth-aware redirects (splash → welcome → dashboard).
- **Firebase Auth** for authentication, with a swappable repository abstraction (`IAuthRepository`).
- **Clean Architecture** — domain interfaces, in-memory data implementations, and presentation layers.
- **Preview Mode** — a stub `AuthRepository` lets the app run end-to-end without Firebase keys.
- **Comprehensive tests** — unit tests for repositories/providers/routing and widget tests for all screens.

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        UI (Screens/Widgets)                   │
│   Dashboard · Tasks · Notes · Calendar · Chat · Settings      │
└───────────────┬───────────────────────────┬─────────────────┘
                │ watches                    │ reads/writes
                ▼                            ▼
        ┌───────────────────┐      ┌──────────────────────────┐
        │  Riverpod State    │      │  Repositories (IAuth,      │
        │  (Notifiers,       │      │  ITask, INote, ICalendar,  │
        │   Providers)       │      │  ChatRepository)          │
        └─────────┬──────────┘      └────────────┬─────────────┘
                  │                                │
                  ▼                                ▼
        ┌───────────────────┐      ┌──────────────────────────┐
        │  GoRouter (auth    │      │  Data Sources             │
        │   redirect logic)  │      │  • In-memory stores        │
        └─────────┬──────────┘      │  • Firebase Auth (opt-in)  │
                  │                └──────────────────────────┘
                  ▼
        ┌───────────────────┐
        │  Firebase / Auth   │  (configured via flutterfire)
        └───────────────────┘

Layers: Domain (entities + interfaces) → Data (implementations) → Presentation (UI + state).
```

---

## 📸 Screenshots Checklist

The following screenshots are needed for the DevPost gallery:

- [ ] **Splash screen** — LifeOS logo with fade-in and loading indicator.
- [ ] **Welcome screen** — onboarding/entry with sign-in and sign-up CTAs.
- [ ] **Login screen** — email/password + Google sign-in.
- [ ] **Register screen** — account creation form with validation.
- [ ] **Dashboard** — feature cards grid (light mode).
- [ ] **Dashboard (Dark)** — same grid in dark mode.
- [ ] **Tasks** — empty state and a populated list with priority chips.
- [ ] **Notes** — note cards with pinning and categories.
- [ ] **Calendar** — monthly grid with an events detail panel.
- [ ] **AI Chat** — conversation with the assistant and the message input.
- [ ] **Settings** — theme toggle, notifications, sign-out.
- [ ] **Responsive** — dashboard on tablet/desktop showing the wider grid.

---

## 🎬 Demo Video Checklist

Key moments to capture in the 2–3 minute demo:

- [ ] App boots into the splash screen and redirects based on auth state.
- [ ] Signed-out user lands on Welcome → taps "Create account".
- [ ] Register form validates input (e.g., rejects a bad email).
- [ ] After sign-in, the user is routed to the Dashboard.
- [ ] Create a **task** with priority, category, and due date; mark it done.
- [ ] Create a **note**, pin it, and search for it.
- [ ] Open **Calendar**, add an event, and navigate months.
- [ ] Ask the **AI Chat** about "my tasks" and "my schedule" to show contextual replies.
- [ ] Toggle **Dark Mode** from Settings and show persistence.
- [ ] Show the app running on **Web** (and optionally mobile) from one codebase.

---

## 🚀 Deployment Checklist

- [ ] Firebase project created and `flutterfire configure` run for each target platform.
- [ ] `firebase_options.dart` populated (kept out of git via `.gitignore`).
- [ ] Platform signing configured (Apple provisioning / Android keystore).
- [ ] `flutter pub get` and `flutter analyze` clean.
- [ ] `flutter test` green (82 tests).
- [ ] Build artifacts produced per target (see README deployment section).

---

## ⚠️ Known Limitations

- **AI responses are stubbed** in this build — the chat returns scripted, contextual replies
  instead of calling a live LLM. A production build would connect to an AI model/API.
- **Firebase is optional** — without `flutterfire configure`, the app runs in Preview Mode using
  stub auth and in-memory data (no real persistence or multi-device sync).
- **In-memory repositories** mean data resets when the app restarts (no cloud or local DB yet).
- **No offline sync** between devices.

---

## 🗺️ Future Roadmap

- **Live AI integration** — connect the chat to a real LLM with retrieval over the user's tasks/notes.
- **Cloud persistence** — Firestore-backed repositories for tasks, notes, and events.
- **Cross-device sync** — real-time updates across phone, tablet, and web.
- **Smart reminders** — AI-suggested scheduling and priority adjustments.
- **Widgets & shortcuts** — home-screen widgets and quick-add actions.
- **Collaboration** — shared lists and calendars for families and teams.
- **Accessibility pass** — screen-reader, contrast, and dynamic-type refinements.

---

## 📄 License

MIT — see the [LICENSE](LICENSE) file for details.
