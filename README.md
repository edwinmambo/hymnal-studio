# Hymnal Studio

[![Flutter Tests](https://img.shields.io/badge/Flutter%20Tests-Passing-brightgreen)](https://github.com/edwinmambo/hymnal-studio)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A sleek, modern, offline-first worship presentation and hymnal platform built with Flutter for Android, Windows, macOS, and Web.

Hymnal Studio is designed from the ground up for church worship leaders, AV operators, and musicians. It integrates multi-hymnal libraries (*Christ in Song*, *Seventh-day Adventist Hymnal*, *SDAH Extended*, and African regional hymnals), zero-install local WebSocket casting, an interactive MIDI accompaniment synthesizer with real-time pitch transposition, and high-fidelity vector sheet music scores.

---

## Key Features

### 1. Multi-Hymnal Library & Quick Jump HUD
* **Instant Number Jump**: Jump directly to any hymn by number (e.g. `433`, `cis 511`, `sdah 108`, `ext 701`, `km 12`).
* **Fuzzy Title & Lyric Search**: Search instantaneously across titles, lyrics, authors, and scripture references.
* **Pre-Loaded Hymnal Catalogs**:
  * **Christ in Song (1908)**: Historic Adventist revival hymns including beloved classics omitted from modern books:
    * *Peace, Be Still!* ("Master, the tempest is raging" • CIS #433)
    * *Dare to be a Daniel* ("Standing by a purpose true" • CIS #511)
    * *Hold the Fort* ("Ho, my comrades, see the signal" • CIS #516)
    * *When the Roll is Called Up Yonder* (CIS #588)
  * **Seventh-day Adventist Hymnal (1985)**: Core public domain standards (*Great Is Thy Faithfulness*, *Amazing Grace*, *Lift Up the Trumpet*, *We Have This Hope*, *It Is Well With My Soul*).
  * **Extended & Gospel Favorites**: Camp meeting and youth quartet staples (*Till the Storm Passes By*, *Dwelling in Beulah Land*).
  * **Regional African Hymnals**:
    * *Kristu Munzwiyo* (Shona, Zimbabwe)
    * *UKristu Esihlabelelweni* (Ndebele / Zulu)
    * *Nyimbo za Kristo* (Swahili, East Africa)

### 2. Intelligent Slide Formatter ("Well-Formatted Casting")
* **Smart Couplet Chunking**: Automatically divides 6–8 line stanzas into crisp 2-to-4 line presentation slides to keep lyrics large and readable from the back row of a sanctuary.
* **Auto-Chorus Insertion**: Automatically inserts the refrain slide after each verse without bloating stored database entries.
* **Dynamic Typography**: Viewport-aware font fitting prevents dangling words and awkward wrapping on 16:9, 4:3, or ultra-wide displays.

### 3. Multi-Transport Casting Engine
* **Zero-Install Audience Display**: The app embeds a local HTTP and WebSocket server (`shelf`). Any Smart TV browser, projector computer, Android TV, or tablet on the church Wi-Fi navigates to `http://<operator-ip>:8080` (or scans the on-screen QR code) to become an audience display.
* **Sub-10ms Latency**: Real-time state synchronization over local WebSockets with zero video compression lag or artifacts.
* **Live Operator Controls**:
  * **Blackout (B)**: Instantly blanks the audience display to pure black.
  * **Clear Text (C)**: Hides lyric lines while preserving ambient background themes.
  * **Curated Themes**: Midnight Navy, Warm Gold, Sapphire Blue, and OLED Pure Black.

### 4. Audio & MIDI Accompaniment Engine
* **Live Pitch Transposition**: Transpose keys by semitones (±1 to ±4 st) in real-time so song leaders can adapt the melody to congregational vocal ranges.
* **Tempo Control**: Smooth BPM slider (50 to 160 BPM) for accompaniment pacing.
* **Progression Indicator**: Visual beat and note progression tracking during congregational singing.

### 5. Vector Sheet Music & Score Viewer
* **Crisp Vector SVGs**: High-resolution SATB 4-part hymn scores that scale infinitely on tablets and monitors without pixelation.
* **Stage Mode Inversion**: Toggle between dark stage mode and classic print paper mode.
* **Transposed Chord Strip**: Displays live chord notations transposed to match the active key.
* **Interactive Zoom**: Pinch-to-zoom and pan for church pianists and choir directors.

---

## Getting Started

### Prerequisites
* Flutter SDK `^3.12.2` (Dart `^3.44.0` or higher)

### Run Locally
```sh
flutter pub get
flutter run -d chrome      # Web
flutter run -d windows     # Windows Desktop
flutter run -d android     # Android
```

### Verify & Test
```sh
flutter test
flutter analyze
```

### Regenerate Assets
To regenerate the catalog JSON, vector SVG scores, and MIDI sequences:
```sh
dart run tool/generate_assets.dart
```

---

## Author
* **Edwin Mambo** ([@edwinmambo](https://github.com/edwinmambo))
