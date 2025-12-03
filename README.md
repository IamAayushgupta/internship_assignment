# 🧘‍♀️ Yoga Home Screen App

A beautiful, modern Flutter application for yoga and wellness enthusiasts. Features a clean Material Design 3 interface with seamless API integration, dynamic content loading, and an intuitive user experience.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Screenshots

<p align="center">
  <img src="screenshots/home_screen.png" width="250" alt="Home Screen"/>
  <img src="screenshots/activity_screen.png" width="250" alt="Activity Screen"/>
</p>

## ✨ Features

- **🏠 Home Dashboard** - Comprehensive overview with all yoga content
- **🎬 Continue Watching** - Track your yoga journey with beautiful carousels
- **🧘 Yoga Categories** - Browse 6 different yoga styles (Vinyasa, Ashtanga, etc.)
- **📺 Popular Videos** - Curated collection with calorie and duration stats
- **📊 Activity Tracking** - Dedicated section for monitoring your progress
- **🔔 Notifications** - Real-time notification badge system
- **🔍 Search** - Quick search functionality for finding content
- **🎨 Modern UI/UX** - Material Design 3 with smooth animations

## 🏗️ Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   └── home_response.dart            # All data models with JSON parsing
├── services/                          # Business logic layer
│   └── api_service.dart              # API communication
├── screens/                           # UI screens
│   └── home_screen.dart              # Main home screen
└── widgets/                           # Reusable UI components
    ├── header_section.dart           # Header with greeting & notifications
    ├── continue_watching_carousel.dart # Horizontal video carousel
    ├── yoga_category_grid.dart        # Category grid layout
    ├── popular_videos_list.dart       # Vertical video list
    └── bottom_nav_bar.dart            # Bottom navigation
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- A device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/yoga-home-screen.git
   cd yoga-home-screen
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

The app connects to a REST API endpoint. Update the API URL in `lib/services/api_service.dart` if needed:

```dart
static const String baseUrl = 'https://api.prosignings.online/api';
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0              # HTTP requests
  google_fonts: ^6.1.0      # Custom fonts (Poppins)

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## 🔌 API Integration

### Endpoint
```
POST https://api.prosignings.online/api/home
```

### Request Body
```json
{
  "userId": "randomstring"
}
```

### Response Structure
```json
{
  "header": {
    "greeting": "Good Morning, Karthick",
    "notificationCount": 1,
    "searchPlaceholder": "Search any destination",
    "shareEnabled": true
  },
  "continueWatching": {
    "current": { ... },
    "next": { ... }
  },
  "yogaCategories": {
    "list": [ ... ]
  },
  "popularVideos": {
    "list": [ ... ]
  }
}
```

## 🎨 Design System

### Color Palette
- **Primary**: `#6C63FF` (Purple)
- **Secondary**: `#764BA2` (Deep Purple)
- **Background**: `#F5F5F5` (Light Grey)
- **Surface**: `#FFFFFF` (White)
- **Text Primary**: `#000000` (Black)
- **Text Secondary**: `#757575` (Grey)

### Typography
- **Font Family**: Poppins (via Google Fonts)
- **Headings**: Bold (600-700 weight)
- **Body Text**: Regular (400 weight)

### Spacing
- **Padding**: 20px (consistent throughout)
- **Section Gaps**: 32px
- **Card Radius**: 16-20px

## 📂 Project Structure Details

### Models (`lib/models/home_response.dart`)
- `HomeResponse` - Root model
- `Header` - App header data
- `ContinueWatching` - Continue watching section
- `ContinueWatchingItem` - Individual video item
- `YogaCategories` - Categories collection
- `YogaCategory` - Single category
- `PopularVideos` - Popular videos collection
- `PopularVideo` - Single video
- `VideoStats` - Video statistics

### Services (`lib/services/api_service.dart`)
- `fetchHomeData()` - Fetches data from API with error handling

### Widgets
- **HeaderSection** - Displays greeting, notifications, and search bar
- **ContinueWatchingCarousel** - PageView carousel with image overlays
- **YogaCategoryGrid** - 3-column responsive grid
- **PopularVideosList** - Scrollable list of videos
- **CustomBottomNavBar** - 4-tab navigation system

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📱 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🐛 Known Issues

- None at the moment! 🎉

## 🛣️ Roadmap

- [ ] State Management (Provider/Riverpod)
- [ ] User Authentication
- [ ] Video Player Integration
- [ ] Favorites/Bookmarks
- [ ] Progress Analytics Dashboard
- [ ] Offline Mode with Caching
- [ ] Push Notifications
- [ ] Dark Mode Support
- [ ] Localization (i18n)
- [ ] Unit & Widget Tests

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## 👨‍💻 Author

Aayush Gupta
- LinkedIn: (https://www.linkedin.com/in/aayush-gupta-113277276/)
- Email: aayush00768@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design guidelines
- Google Fonts for typography
- All contributors and supporters

## 📞 Support

For support, email aayush00768@gmail.com or open an issue in the GitHub repository.

---

<p align="center">Made with ❤️ and Flutter</p>
<p align="center">⭐ Star this repo if you find it helpful!</p>
