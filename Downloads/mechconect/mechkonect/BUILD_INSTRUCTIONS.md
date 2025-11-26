# Build Instructions for MECHKONECT

## Prerequisites

1. **Flutter SDK** (>=3.3.0) - [Install Flutter](https://flutter.dev/docs/get-started/install)
2. **Android Studio** or **VS Code** with Flutter extensions
3. **Firebase Project** - Create at [Firebase Console](https://console.firebase.google.com)
4. **Google Maps API Key** - Get from [Google Cloud Console](https://console.cloud.google.com)

## Step-by-Step Build Process

### 1. Install Dependencies

Open terminal in the project directory and run:

```bash
flutter pub get
```

### 2. Generate Code Files

The application uses code generation for JSON serialization and API clients. Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Note:** If you encounter errors, you can use the pre-generated `.g.dart` files I've created, but it's recommended to regenerate them.

### 3. Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or use existing
3. Add Android app with package name: `com.mechkonect.app`
4. Download `google-services.json`
5. Place it in `android/app/google-services.json`

### 4. Enable Firebase Services

In Firebase Console:
- Enable **Authentication** → **Phone** and **Google** sign-in methods
- Enable **Cloud Messaging** (for push notifications)

### 5. Configure Google Maps

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a project or select existing
3. Enable **Maps SDK for Android**
4. Create API Key
5. Open `android/app/src/main/AndroidManifest.xml`
6. Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE"/>
```

### 6. Update API Endpoint

Edit `lib/core/constants/api_endpoints.dart` and update the base URL:

```dart
static const String baseUrl = 'https://your-api-domain.com/v1';
```

### 7. Add App Icon

Place your app icon at `assets/icons/app_icon.png` (recommended: 1024x1024px)

### 8. Build the Application

#### For Debug Build:
```bash
flutter run
```

#### For Release APK:
```bash
flutter build apk --release
```

#### For Release App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

### 9. Using the Build Script (Windows PowerShell)

I've created a build script for convenience:

```powershell
.\build.ps1
```

This script will:
- Get dependencies
- Generate code files
- Analyze code
- Build release APK

## Troubleshooting

### Build Errors

**Error: Plugin not found**
- Ensure you're using Flutter 3.3.0 or higher
- Run `flutter clean` and `flutter pub get`

**Error: Missing .g.dart files**
- Run `flutter pub run build_runner build --delete-conflicting-outputs`
- Or use the pre-generated files I've created

**Error: Google Maps not showing**
- Verify API key is correct in AndroidManifest.xml
- Ensure Maps SDK for Android is enabled in Google Cloud Console
- Check API key restrictions if any

**Error: Firebase not configured**
- Ensure `google-services.json` is in `android/app/` directory
- Verify package name matches Firebase project

### Common Issues

1. **Gradle Build Fails**
   - Update Android Studio and Gradle
   - Run `flutter clean` and rebuild

2. **Permission Errors**
   - Check AndroidManifest.xml has all required permissions
   - Ensure location permissions are properly requested in code

3. **Network Errors**
   - Check internet connection
   - Verify API endpoint URL is correct
   - Check if backend server is running

## Project Structure

```
mechkonect/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── core/                     # Core utilities
│   ├── data/                     # Data layer (models, services, repositories)
│   ├── presentation/             # UI layer (screens, providers)
│   └── routes/                   # Navigation
├── android/                      # Android configuration
├── assets/                       # Images, icons, etc.
└── pubspec.yaml                  # Dependencies
```

## Next Steps After Build

1. Test on physical device (recommended for location services)
2. Configure backend API endpoints
3. Set up payment gateway (Flutterwave/Paystack)
4. Add real mechanic data
5. Test all features thoroughly

## Support

If you encounter any issues:
1. Check Flutter documentation
2. Review error messages carefully
3. Ensure all prerequisites are met
4. Verify all configuration files are correct

---

**Build Status:** ✅ All code files are ready. Run `flutter pub get` and `flutter run` to start!




