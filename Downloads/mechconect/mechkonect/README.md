# MECHKONECT - Flutter Application

A comprehensive mobile application connecting vehicle owners in Uganda with vetted mechanics and emergency services in real-time.

## Features

- ✅ **Authentication System**: Phone OTP and Google Sign-In
- ✅ **Real-time Map**: Google Maps integration with mechanic markers
- ✅ **Mechanic Discovery**: Search, filter, and view mechanic details
- ✅ **Booking System**: Create, track, and manage bookings
- ✅ **Payment Integration**: Digital wallet with payment processing
- ✅ **SOS Emergency**: Quick access to emergency services
- ✅ **Offline-First**: SQLite database with sync capability
- ✅ **Dark Mode**: Full dark mode support

## Setup Instructions

### Prerequisites

- Flutter SDK (>=3.3.0)
- Android Studio / VS Code
- Firebase project setup
- Google Maps API key

### Installation Steps

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd mechkonect
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code files**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Firebase Setup**

   - Create a Firebase project at https://console.firebase.google.com
   - Add Android app to Firebase project
   - Download `google-services.json` and place it in `android/app/`
   - Enable Phone Authentication and Google Sign-In in Firebase Console

5. **Google Maps Setup**

   - Get API key from Google Cloud Console
   - Enable Maps SDK for Android
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`

6. **Update API Endpoint**

   - Update base URL in `lib/core/constants/api_endpoints.dart`
   - Configure Dio interceptors in `lib/data/services/api_service.dart` if needed

7. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core utilities and constants
│   ├── constants/              # Colors, text styles, dimensions, API endpoints
│   ├── theme/                  # Light and dark themes
│   ├── utils/                  # Validators, formatters
│   └── widgets/                # Reusable widgets
├── data/                       # Data layer
│   ├── models/                 # Data models
│   ├── repositories/           # Data repositories
│   └── services/               # API, storage, location, notifications
├── presentation/               # UI layer
│   ├── screens/                # All app screens
│   └── providers/              # State management (Provider)
└── routes/                     # App routing configuration
```

## Key Files to Configure

1. **API Endpoints**: `lib/core/constants/api_endpoints.dart`
2. **Google Maps Key**: `android/app/src/main/AndroidManifest.xml`
3. **Firebase Config**: `android/app/google-services.json`
4. **App Package**: `android/app/build.gradle` (applicationId)

## Next Steps

1. Generate model files: Run `flutter pub run build_runner build`
2. Add Firebase configuration files
3. Configure backend API endpoints
4. Add app icons to `assets/icons/app_icon.png`
5. Test on physical device for location services
6. Configure payment gateway (Flutterwave/Paystack)

## Troubleshooting

- **Build errors**: Run `flutter clean && flutter pub get`
- **Code generation**: Run `flutter pub run build_runner build --delete-conflicting-outputs`
- **Google Maps not showing**: Check API key and enable Maps SDK
- **Firebase errors**: Ensure `google-services.json` is in correct location

## License

This project is proprietary software.
