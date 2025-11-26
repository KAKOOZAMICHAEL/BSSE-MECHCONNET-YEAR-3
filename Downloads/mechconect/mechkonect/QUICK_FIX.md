# Quick Fix for Flutter PATH Error

## The Problem
```
flutter : The term 'flutter' is not recognized
```
This means Flutter is not in your system PATH.

## Quick Solution

### Step 1: Find Flutter Installation

Run this PowerShell script I created:
```powershell
.\find_flutter.ps1
```

This will search for Flutter on your system and show you where it's installed.

### Step 2: Add Flutter to PATH (Temporary - Current Session Only)

If Flutter is found, you can add it to PATH for your current PowerShell session:

```powershell
# Replace with the actual path shown by find_flutter.ps1
$env:Path += ";C:\src\flutter\bin"
```

Then test:
```powershell
flutter --version
```

### Step 3: Add Flutter to PATH (Permanent)

**Method 1: Using GUI (Recommended)**
1. Press `Win + X` and select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "System variables", find "Path" and click "Edit"
5. Click "New" and add: `C:\src\flutter\bin` (use your actual path)
6. Click OK on all dialogs
7. **Close and reopen PowerShell**

**Method 2: Using PowerShell (Run as Administrator)**
```powershell
# Run PowerShell as Administrator
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\src\flutter\bin",
    "Machine"
)
```
Replace `C:\src\flutter\bin` with your actual Flutter path.

### Step 4: Verify Installation

After adding to PATH, restart PowerShell and run:
```powershell
flutter doctor
```

This will show you what's installed and what's missing.

### Step 5: Build the App

Once Flutter is working:
```powershell
cd C:\Users\miche\Desktop\mechkonect
flutter pub get
flutter run
```

## If Flutter is Not Installed

1. **Download Flutter SDK:**
   - Visit: https://flutter.dev/docs/get-started/install/windows
   - Download the ZIP file
   - Extract to `C:\src\flutter` (or any location without spaces)

2. **Add to PATH:**
   - Follow Step 3 above

3. **Run Flutter Doctor:**
   ```powershell
   flutter doctor
   ```

4. **Install missing components** as shown by `flutter doctor`

## Alternative: Use Android Studio

If you have Android Studio:
1. Open Android Studio
2. Go to File → Settings → Languages & Frameworks → Flutter
3. Check "Flutter SDK path" - this shows where Flutter is
4. Add that path's `bin` folder to PATH (see Step 3)




