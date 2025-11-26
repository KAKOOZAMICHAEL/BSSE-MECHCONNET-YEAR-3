# Flutter Setup Guide for MECHKONECT

## Problem
You're seeing `flutter : The term 'flutter' is not recognized` because Flutter SDK is either:
1. Not installed on your system
2. Installed but not added to your system PATH

## Solution Options

### Option 1: Install Flutter (If Not Installed)

1. **Download Flutter SDK**
   - Visit: https://flutter.dev/docs/get-started/install/windows
   - Download the latest stable Flutter SDK ZIP file
   - Extract it to a location like `C:\src\flutter` (avoid spaces in path)

2. **Add Flutter to PATH**
   - Open "Environment Variables" in Windows
   - Add Flutter's `bin` folder to your PATH:
     - Example: `C:\src\flutter\bin`
   - Restart your terminal/PowerShell

3. **Verify Installation**
   ```powershell
   flutter doctor
   ```

### Option 2: Find Existing Flutter Installation

If Flutter is already installed, you need to find it and add it to PATH.

**Common Flutter Installation Locations:**
- `C:\src\flutter\bin`
- `C:\flutter\bin`
- `C:\Users\YourName\flutter\bin`
- `C:\tools\flutter\bin`

**To find Flutter:**
1. Search for `flutter.bat` in File Explorer
2. Note the folder path (it should be in a `bin` folder)
3. Add the `bin` folder to your PATH

### Option 3: Use Flutter from Android Studio

If you have Android Studio installed:
1. Open Android Studio
2. Go to File → Settings → Languages & Frameworks → Flutter
3. Check the "Flutter SDK path" - this shows where Flutter is installed
4. Add that path's `bin` folder to your system PATH

## Quick Fix: Add Flutter to PATH in Current Session

Run these commands in PowerShell (replace with your actual Flutter path):

```powershell
# Replace this path with your actual Flutter installation path
$flutterPath = "C:\src\flutter\bin"

# Add to PATH for current session
$env:Path += ";$flutterPath"

# Verify it works
flutter --version
```

## Permanent Fix: Add Flutter to System PATH

### Method 1: Using GUI
1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Go to "Advanced" tab
3. Click "Environment Variables"
4. Under "System variables", select "Path" and click "Edit"
5. Click "New" and add your Flutter `bin` folder path
6. Click "OK" on all dialogs
7. **Restart PowerShell/terminal**

### Method 2: Using PowerShell (Run as Administrator)

```powershell
# Run PowerShell as Administrator, then:
$flutterPath = "C:\src\flutter\bin"  # Replace with your path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$flutterPath", "Machine")
```

## Verify Flutter is Working

After adding to PATH, restart PowerShell and run:

```powershell
flutter doctor
```

This will show you what's installed and what's missing.

## Install Missing Components

Based on `flutter doctor` output, you may need to:

1. **Accept Android licenses:**
   ```powershell
   flutter doctor --android-licenses
   ```

2. **Install Android SDK** (if missing)
   - Install Android Studio
   - Open Android Studio → SDK Manager
   - Install Android SDK Platform-Tools

3. **Install VS Code Flutter extension** (optional but recommended)

## After Flutter is Set Up

Once `flutter doctor` shows everything is ready, you can build the app:

```powershell
cd C:\Users\miche\Desktop\mechkonect
flutter pub get
flutter run
```

## Need Help?

- Check Flutter installation: https://flutter.dev/docs/get-started/install/windows
- Flutter troubleshooting: https://flutter.dev/docs/get-started/install/windows#troubleshooting




