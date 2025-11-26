# MECHKONECT Build Script
# Run this script to build the application

Write-Host "Building MECHKONECT Application..." -ForegroundColor Green

# Step 1: Get dependencies
Write-Host "`nStep 1: Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

# Step 2: Generate code files
Write-Host "`nStep 2: Generating code files..." -ForegroundColor Yellow
flutter pub run build_runner build --delete-conflicting-outputs

# Step 3: Analyze code
Write-Host "`nStep 3: Analyzing code..." -ForegroundColor Yellow
flutter analyze

# Step 4: Build APK
Write-Host "`nStep 4: Building APK..." -ForegroundColor Yellow
flutter build apk --release

Write-Host "`nBuild completed successfully!" -ForegroundColor Green
Write-Host "APK location: build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor Cyan




