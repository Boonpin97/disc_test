# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

```bash
flutter pub get
flutter run -d chrome
flutter run -d windows
flutter test
flutter test test/widget_test.dart
flutter analyze
```

## Architecture

This project is a Flutter DISC personality test app, primarily targeted at web, but still configured for the default Flutter multi-platform targets.

The app is split by responsibility:

- `lib/main.dart` bootstraps the `MaterialApp`, theme, and intro screen.
- `lib/models/` contains the questionnaire domain models:
  - `word.dart` for `DiscCategory` and `Word`
  - `word_group.dart` for four-word groups
  - `answer.dart` for MOST / LEAST selections
  - `disc_result.dart` for scored totals and dominant composite logic
- `lib/data/` contains static source content:
  - `word_groups.dart` for all 24 questionnaire groups
  - `glossary.dart` for inline word definitions
  - `disc_profiles.dart` for D / I / S / C interpretation content
- `lib/screens/` contains the three top-level flows:
  - `intro_screen.dart`
  - `questionnaire_screen.dart`
  - `results_screen.dart`
- `lib/widgets/` contains reusable presentation pieces:
  - `word_group_card.dart`
  - `progress_bar.dart`
  - `disc_bar_chart.dart`
  - `disc_colors.dart`
- `lib/services/` contains app logic:
  - `scoring_service.dart` for score calculation
  - `html_report_builder.dart` for standalone HTML export generation
  - `export_service.dart` plus platform-specific export implementations

No external state management package is used. Questionnaire state is held locally in the questionnaire screen with a `List<Answer>`.

## Key Behaviors

- Questionnaire validation requires all 24 groups to have distinct MOST and LEAST choices before submission.
- Scoring uses MOST counts, LEAST counts, and `COMPOSITE = MOST - LEAST`.
- Dominant style is determined from the highest composite score, with ties resolved in `D > I > S > C` order.
- HTML export is web-only via conditional exports, while non-web platforms throw an unsupported error if download is attempted.

## Key Files

- `lib/main.dart`
- `lib/screens/questionnaire_screen.dart`
- `lib/screens/results_screen.dart`
- `lib/services/scoring_service.dart`
- `lib/services/html_report_builder.dart`
- `test/widget_test.dart`
