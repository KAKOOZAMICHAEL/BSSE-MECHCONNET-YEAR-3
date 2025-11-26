# Fix Anonymous Sign-In Error: CONFIGURATION_NOT_FOUND

## The Error
```
Exception: Anonymous sign-in failed:
[firebase_auth/unknown] An internal error has occurred. [ CONFIGURATION_NOT_FOUND ]
```

This error occurs because **Anonymous Authentication is NOT enabled** in your Firebase Console.

---

## ✅ SOLUTION: Enable Anonymous Auth in Firebase Console

### Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **mechkonect**

### Step 2: Navigate to Authentication
1. Click **Build** (left sidebar)
2. Click **Authentication**
3. Click **Get started** (if shown) or go to **Sign-in method** tab

### Step 3: Enable Anonymous Provider
1. Look for **Anonymous** in the sign-in providers list
2. Click on **Anonymous**
3. Click the **Enable** toggle switch (turn it ON - blue)
4. Click **Save**

### Expected Result:
- You should see a green checkmark ✅ next to "Anonymous"
- Status should show "Enabled"

---

## 🔍 Verify Configuration

After enabling, verify:

1. **Check Providers Tab**:
   - Go to Authentication → Sign-in method
   - Confirm "Anonymous" shows as "Enabled" ✅

2. **Check Users Tab**:
   - Go to Authentication → Users
   - After testing, you should see anonymous users appearing here with UID like:
     ```
     User ID: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
     Provider: anonymous
     ```

---

## 🧪 Test Anonymous Sign-In

1. **Rebuild your app**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Click "Continue as Guest"** button (once you add it to your UI)

3. **Expected outcome**:
   - User is authenticated anonymously
   - App navigates to home screen
   - No error message appears

---

## 📋 Firebase Security Rules (Optional but Recommended)

For anonymous users to access your Firestore data, update your rules:

### Firestore Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated (including anonymous) users to read
    match /mechanics/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // Mechanics can't be modified by users
    }
    
    // User-specific data
    match /users/{userId} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

### Realtime Database Rules:
```json
{
  "rules": {
    "mechanics": {
      ".read": "auth != null",
      ".write": false
    },
    "users": {
      "$uid": {
        ".read": "auth.uid == $uid",
        ".write": "auth.uid == $uid"
      }
    }
  }
}
```

---

## 🛠️ Troubleshooting

### Issue 1: Still getting "CONFIGURATION_NOT_FOUND"
- **Solution**: 
  - Clear app cache: `flutter clean`
  - Rebuild: `flutter pub get && flutter run`
  - Verify Anonymous is actually toggled **ON** in Firebase Console

### Issue 2: "Anonymous authentication is disabled"
- **Solution**: Go back to Firebase Console and make sure the toggle is blue/enabled

### Issue 3: Users not appearing in Firebase Console
- **Solution**: This is normal - anonymous users may not show up immediately. They'll appear in your analytics.

### Issue 4: Anonymous users can't read data
- **Solution**: Update your Firestore/Database rules as shown above

---

## 📱 UI Implementation (Add This to Your Login Screen)

Once anonymous auth is enabled, add a button to your login/welcome screen:

```dart
// In your login_screen.dart or welcome_screen.dart
ElevatedButton(
  onPressed: () async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInAnonymously();
      
      if (mounted && authProvider.isAuthenticated) {
        context.go('/home'); // Navigate to home
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(vertical: 16),
  ),
  child: const Text('Continue as Guest'),
)
```

---

## ✨ What Happens After Anonymous Sign-In?

1. **Firebase creates a unique UID** for the user
2. **User can browse mechanics** and other public data
3. **User can make bookings** (if you allow it)
4. **Later**, user can upgrade to real account by:
   - Entering phone number → Getting OTP
   - Firebase links phone credential to existing anonymous account
   - Account now has both phone and Firebase UID

---

## 📝 Checklist Before Testing

- [ ] Anonymous authentication is **enabled** in Firebase Console
- [ ] `google-services.json` is in `android/app/`
- [ ] `android/app/build.gradle.kts` has `id("com.google.gms.google-services")`
- [ ] You've added `signInAnonymously()` button to your UI
- [ ] App rebuilt with `flutter clean && flutter run`
- [ ] Firestore/Database rules allow anonymous access

---

## 🔗 Useful Links

- [Firebase Anonymous Auth Docs](https://firebase.google.com/docs/auth/flutter/anonymous-auth)
- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Security Rules Guide](https://firebase.google.com/docs/rules/rules-language)

---

**Once you complete Step 3 above and rebuild the app, anonymous sign-in should work! 🚀**
