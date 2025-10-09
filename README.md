<div align="center">

# Birds of a Feather 🃏

Solitaire-style card merging game built with Flutter.

</div>

## Overview

Birds of a Feather is a simple, addictive solitaire game played on a 4×4 grid. Drag a card onto another card in the same row or column if either:

- The suits match, or
- The ranks are the same or adjacent (e.g., 6 merges with 5 or 7).

The goal is to merge cards until only one card remains on the board.

This repo contains a cross‑platform Flutter app that runs on Web, macOS/Windows/Linux, Android, and iOS.

## Features

- 4×4 grid gameplay with drag-and-drop interactions
- Deterministic seeds for reproducible boards (New Game vs Restart)
- Move history pane and Undo
- Built-in Help dialog and win detection
- Card assets bundled locally (in `cards/`)

## Project Structure

- `lib/`
    - `main.dart`: App UI and drag-and-drop game interactions
    - `birds_of_a_feather.dart`: Core game logic (moves, validation, win/undo)
- `cards/`: PNG assets for playing cards
- Platform folders: `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`
- `pubspec.yaml`: Dependencies and assets configuration

## Prerequisites

- Flutter SDK installed and on your PATH
- Dart SDK (bundled with Flutter)
- For platform targets:
    - Web: a modern browser (Chrome recommended)
    - macOS: Xcode command-line tools and macOS desktop support enabled
    - Windows/Linux: respective desktop support enabled
    - Android: Android Studio + SDKs and an emulator or device
    - iOS: Xcode + CocoaPods and a simulator or device

You can verify your setup with:

```bash
flutter doctor -v
```

## Setup

From the project root:

```bash
flutter pub get
```

## Run

Pick one of the targets below. If you have multiple devices, list them with `flutter devices`.

### Web (Chrome)

```bash
flutter run -d chrome
```

### macOS Desktop

```bash
flutter config --enable-macos-desktop
flutter run -d macos
```

### Windows Desktop

```bash
flutter config --enable-windows-desktop
flutter run -d windows
```

### Linux Desktop

```bash
flutter config --enable-linux-desktop
flutter run -d linux
```

### Android

```bash
flutter run -d android
```

### iOS

```bash
flutter run -d ios
```

## How to Play

1. Each new game deals a random 4×4 layout of cards.
2. Drag a card onto another in the same row or column if:
     - Suits are the same, or
     - Ranks are equal or differ by exactly 1 (A–2, Q–K, 9–10, etc.).
3. The source card disappears and the target becomes the source card.
4. Use Undo to revert the last move, or Restart to replay the same seed.
5. Reduce the board to a single card to win.

## Screenshots

You can add screenshots/GIFs here:

```
docs/
    screenshot-1.png
    gameplay.gif
```

Then embed them above using markdown: `![Gameplay](docs/gameplay.gif)`

## Troubleshooting

- Missing card images? Ensure `cards/` exists and is declared in `pubspec.yaml` under `flutter.assets`.
- Desktop window API errors? The app uses `window_size` on desktop. Make sure desktop support is enabled (`flutter config --enable-<platform>-desktop`).
- iOS build issues related to CocoaPods? Run `pod install` in `ios/` after `flutter pub get`.

## License

This project is provided as-is for educational and personal use. Add a license file if you plan to distribute.

## Authors

Andy and Toai
