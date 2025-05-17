# SpecsOCR

A Flutter app for scanning text from images using OCR (Optical Character Recognition), built with Riverpod and Clean Architecture principles.

## Features

- 📷 **Pick images** from camera or gallery
- 📝 **Scan and extract text** from images using Google ML Kit
- 🕑 **View scan history** (stored locally with SQLite)
- 🗑️ **Clear images and results**
- 🎨 Modern UI with Material Design

## Architecture

- **Riverpod** for state management
- **Clean Architecture**: Separation of presentation, application, domain, and data layers
- **SQLite** for persistent scan history

## Dependencies

- [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
- [`image_picker`](https://pub.dev/packages/image_picker)
- [`google_mlkit_text_recognition`](https://pub.dev/packages/google_mlkit_text_recognition)
- [`sqflite`](https://pub.dev/packages/sqflite)
- [`path`](https://pub.dev/packages/path)

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/flutter_final.git
   cd flutter_final
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

## Folder Structure

```
lib/
├── application/   # Riverpod controllers/providers
├── data/          # Database helpers, data sources
├── domain/        # Models, repositories, use cases
├── presentation/  # UI widgets and screens
└── main.dart
```

## Screenshots

<!-- Add screenshots here if available -->

## License

This project is licensed under the MIT License.

---

Made with ❤️ using Flutter and Riverpod.