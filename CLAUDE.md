# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

Louder for Learning is a grant discovery app for teachers at underfunded school districts. It surfaces relevant educational funding opportunities, lets teachers apply directly in-app, and tracks application status. The core belief: teachers in under-resourced schools deserve equal access to grant money that exists for their students.

## Target Users

K–12 teachers at Title I / underfunded public schools. They are time-poor and often not grant-savvy. The app must feel effortless — find a grant, apply, track it, done.

## Repository Layout — two parallel implementations

This repo contains **two independent apps that implement the same product**, not a frontend/backend pair:

- **`src/app/`** — a React/TypeScript prototype exported from Figma Make (root `package.json`, Vite). It renders the same 10 screens using local-only state (`localStorage` via `profileStorage.ts`, static data in `grantData.ts`). This is the design-reference layer and is **not wired to Firebase** — treat it as the source of truth for visual/UX design, not for backend behavior.
- **`louder_for_learning/`** — the shipping Flutter app (targets iOS/Android/Web via App Store, Google Play, and Firebase Hosting). It has a real Firebase backend (`firebase_auth` + `cloud_firestore`). **This is the app that actually gets published.**

When a screen or flow changes, check whether it needs to change in both trees. They are structured in parallel — e.g. `src/app/components/Dashboard.tsx` ↔ `louder_for_learning/lib/screens/dashboard_screen.dart`, `EditProfile.tsx` ↔ `edit_profile_screen.dart` — but the Flutter side additionally has to thread the change through its repository/service layer if it touches persisted data.

```
Louderforlearningapp/                  ← workspace root
├── CLAUDE.md
├── src/app/                           ← React/TS prototype (Figma Make export, local-only state)
│   └── components/                    ← one screen per file + shadcn/ui primitives in ui/
└── louder_for_learning/               ← Flutter app (the shipping product)
    ├── pubspec.yaml
    ├── firebase.json / firestore.rules / .firebaserc
    └── lib/
        ├── main.dart                  ← entry point, Firebase init, Firestore offline persistence
        ├── app.dart                   ← AppShell: single StatefulWidget owning all nav + auth/profile/grants state
        ├── theme/app_colors.dart      ← brand color constants (canonical; React has no equivalent file — colors are hardcoded inline per component there)
        ├── models/                    ← Grant, GrantApplication
        ├── services/                  ← AuthService, GrantsRepository, ApplicationsRepository, ProfileRepository (Firebase access)
        ├── data/                      ← profile_options.dart, profile_storage.dart (local profile value objects, not persistence)
        ├── widgets/bottom_nav.dart
        └── screens/                   ← one screen per file
```

## Commands

**React prototype** (run from repo root):
```bash
npm i          # install deps
npm run dev    # start Vite dev server
npm run build  # production build
```

**Flutter app** (run from `louder_for_learning/`):
```bash
flutter pub get             # install dependencies
flutter run                 # run on a connected device/simulator
flutter analyze             # lint (flutter_lints, see analysis_options.yaml)
flutter test                # run tests — note: test/widget_test.dart is the unmodified template and references a nonexistent MyApp class; it will not compile until updated to LouderForLearningApp
flutter build apk           # Android release build
flutter build ipa           # iOS release build (requires Xcode on macOS)
flutter build web           # Web build, output to build/web/
```

A `.claude/launch.json` config (`louder-for-learning-web`) serves the *prebuilt* `louder_for_learning/build/web` on port 5050 via `npx serve` — run `flutter build web` first, since it does not build on the fly.

## Architecture

### Navigation
No router package in either implementation — a single top-level stateful widget/component owns an enum/union of screen names and swaps screens via `setState`/React state:
- Flutter: `AppShell` in [app.dart](louder_for_learning/lib/app.dart), screen enum `AppScreen`.
- React: `App` in [App.tsx](src/app/App.tsx), screen union type `Screen`.

```
login → onboarding1 → onboarding2 → dashboard (main)
                                          ↕ (BottomNav tabs)
                                    grant-detail → apply → status
                                    teacher-spotlight
                                    account → edit-profile
```
Bottom nav appears on: `dashboard`, `status`, `account`. Tabs: Grants · Apply · My Status · My Account.

### Data & backend — Flutter only
The Flutter app is the only implementation with a real backend. Firebase Auth handles sign-up/sign-in (email verification is required before a user reaches onboarding/dashboard — see `AuthService` and the login-error branch in `AppShell`). Firestore holds three collections, all accessed through a dedicated repository class in `lib/services/`:

| Collection | Repository | Access pattern |
|---|---|---|
| `grants/{grantId}` | `GrantsRepository` | Read-only from the client; content is managed out-of-band. In-memory cached per session. |
| `users/{userId}` | `ProfileRepository` | Owner-only read/write; the teacher's profile (school, subjects, Title I status). |
| `users/{userId}/applications/{applicationId}` | `ApplicationsRepository` | Owner-only; write-once on submit, streamed (`snapshots()`) for live status updates. |

Access is enforced server-side in [firestore.rules](louder_for_learning/firestore.rules) (per-uid isolation), not just client-side — repository code should not be treated as the security boundary.

The React prototype has no backend: `profileStorage.ts` persists to `localStorage`, and `grantData.ts` is a static hardcoded list. Don't add Firebase calls there — it exists to prototype UI, not to be deployed.

### Data model
`Grant` and `GrantApplication` are duplicated as a TS type (React) and a Dart class (Flutter) — keep both in sync when the schema changes. Flutter's Firestore-backed versions (`lib/models/grant.dart`, `lib/models/application.dart`) are the canonical shape; `ApplicationStatus` is a 5-state enum (`submitted → underReview → approved/rejected → funded`).

## Brand Colors

| Name | Hex | Usage |
|------|-----|-------|
| primary | `#1B7A50` | Buttons, active states, headers |
| dark | `#134F34` | Backgrounds, gradients, overlays |
| light | `#EBF6F0` | Light-green backgrounds, banners |
| accent | `#4D9E72` | Secondary text on green |
| accentLight | `#A7D9BC` | Subtle labels on dark green |
| danger | `#DC2626` | Errors, destructive actions |

In Flutter, always reference `AppColors.*` from [app_colors.dart](louder_for_learning/lib/theme/app_colors.dart) — never raw hex in widget files. The React prototype has no shared color constants; components hardcode the same hex values inline (this is existing prototype debt, not a convention to extend).

## Code Conventions

- One screen per file. Flutter screens are `StatefulWidget` only when they hold local UI state.
- Icons use `Icons.*` (Material) mapped as closely as possible to the original Lucide icons used in the React prototype.
- No comments on obvious code. Comments only where the "why" is non-obvious (see the existing repository/service classes for the expected style — they explain security/consistency invariants, not what the code does).
