# disc_test

DISC personality test web app (Personal DiSCernment Inventory).

Users answer 24 questions (each with 4 words) by selecting one **MOST** and one **LEAST** word per question. The app scores **MOST**, **LEAST**, and **COMPOSITE = MOST - LEAST**, determines a dominant style (D/I/S/C), matches the composite vector to the closest representative DiSC pattern, and renders results with charts plus interpretation text.

The results page supports exporting as:

- Downloadable standalone **HTML** report (web-only)
- Downloadable **PDF** report (web-only; built with the `pdf` package)

## Requirements

- Flutter SDK (Dart SDK constraint in `pubspec.yaml`: `sdk: ^3.8.0`)

## Run Locally

```bash
flutter pub get
flutter run -d chrome
```

Other useful commands:

```bash
flutter test
flutter analyze
```

## Build For Web

```bash
flutter build web --release
```

Output goes to `build/web` (this is what Firebase Hosting serves via `firebase.json`).

## Deploy (Firebase Hosting)

This repo is configured to deploy the SPA build output (`build/web`) to Firebase Hosting with a rewrite to `/index.html` for all routes.

1. Ensure the Firebase CLI is installed and authenticated.
2. Build the web app.
3. Deploy hosting.

```bash
flutter build web --release
firebase deploy --only hosting
```

The default Firebase project is configured in `.firebaserc`.

## Project Layout (High Level)

- `lib/main.dart`: app bootstrap + theme + routes (starts at `IntroScreen`)
- `lib/screens/`: intro, questionnaire, results
- `lib/models/`: domain models (`Answer`, `WordGroup`, `DiscResult`, etc.)
- `lib/data/`: static questionnaire content + glossary + interpretation profiles + representative patterns
- `lib/services/`: scoring, pattern matching, HTML/PDF report builders, export/download helpers
- `lib/widgets/`: reusable UI components (progress bar, charts, cards)
