# 🎵 MusicPlayer

**MusicPlayer** is a modern, lightweight Flutter application for playing local audio files on Android devices. It offers a rich, responsive UI, integrates background playback, and automatically displays album artwork.

---

## 📌 Features

* **Play Local Songs:** Fetch and play songs stored on your device.
* **Album Artwork Support:** Automatically displays song artwork, with a fallback image if none exists.
* **Background Audio:** Support for background playback using `just_audio_background`.
* **Audio Controls:** Play, pause, next, previous, and toggle playback easily.
* **Custom UI Components:** Includes a bottom player, song list items, and interactive buttons.
* **Permission Handling:** Automatic request and management of storage/audio permissions.
* **Smooth Animations:** Includes Lottie animations and avatar glow effects.

---

## 🛠️ Built With

* [Flutter](https://flutter.dev/) – UI toolkit for building cross-platform apps
* [just\_audio](https://pub.dev/packages/just_audio) – Audio playback
* [just\_audio\_background](https://pub.dev/packages/just_audio_background) – Background audio playback
* [on\_audio\_query](https://pub.dev/packages/on_audio_query) – Query audio files from device storage
* [permission\_handler](https://pub.dev/packages/permission_handler) – Request and handle app permissions
* [marquee](https://pub.dev/packages/marquee) – Scrolling text widget for song titles
* [audio\_video\_progress\_bar](https://pub.dev/packages/audio_video_progress_bar) – Progress bar for audio playback
* [avatar\_glow](https://pub.dev/packages/avatar_glow) – Glow animation for UI components
* [lottie](https://pub.dev/packages/lottie) – Lottie animations

---

## 📂 Project Structure

```
lib/
├── controller/
│   └── audio_controller.dart       # Audio controller with all playback logic
├── model/
│   └── local_song_model.dart       # Model for local song data
├── utils/
│   └── custom_text_style.dart      # Custom text styling helpers
├── widgets/
│   ├── bottom_player.dart          # Bottom playback widget
│   ├── m_button.dart               # Custom button widget
│   └── song_list_item.dart         # List item widget for each song
└── allsongscreen.dart              # Main screen showing all songs
```

---

## ⚙️ Getting Started

### Prerequisites

* Flutter SDK >= 3.8.1
* Android device/emulator with local audio files

### Installation

1. **Clone the repository:**

```bash
git clone <repository_url>
cd musicplayer
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Run the app:**

```bash
flutter run
```

> Ensure that you grant the necessary storage/audio permissions when prompted.

---

## 🎶 Usage

1. Launch the app and grant **Storage/Audio permissions**.
2. Browse your local music library.
3. Tap a song to play it.
4. Use the bottom player to control playback (play/pause, next, previous).
5. Album artwork is displayed if available, otherwise a default fallback image appears.

---

## 🔧 AudioController Overview

`AudioController` handles all playback logic:

* **Loading Songs:** Queries songs from device storage and fetches artwork.
* **Play/Pause/Resume:** Methods for controlling audio playback.
* **Next/Previous:** Navigate through the playlist.
* **State Management:** Uses `ValueNotifier` to notify UI about current song and playback state.

---

## 🎨 Customization

* **Theme Colors:** Modify in `AppColors` file.
* **Fonts:** Configurable via `pubspec.yaml` under `fonts:` section.
* **Assets:** Add animations or images in `assets/animation/` and `assets/images/`.

---

## ⚠️ Permissions

The app requires:

* `Permission.storage` (for Android < 33)
* `Permission.audio` (for Android 33+)

If denied, a **custom dialog** guides the user to open app settings.

---

## 📄 License

This project is **private** and **not published on pub.dev**. Modify freely for personal or learning purposes.

---

✅ **Pro Tip:** The app can be further enhanced with playlists, search functionality, and dark mode support for a more complete music player experience.

---
