# Anonymous Authentication Setup Guide

This guide explains how to enable anonymous sign-in in Firebase for your MechKonect app. This is useful for allowing users to explore the app without providing credentials initially.

## Step 1: Enable Anonymous Authentication in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **mechkonect** (or your project name)
3. Navigate to **Authentication** → **Sign-in method**
4. Find **Anonymous** in the list of sign-in providers
5. Click the toggle to **Enable** it
6. Click **Save**

## Step 2: Understand the Code Implementation

### Anonymous Sign-In Method (Already Added)

I've added a new method `signInAnonymously()` to your `AuthRepository` class:

```dart
Future<UserModel> signInAnonymously() async {
  try {
    final userCredential = await _firebaseAuth.signInAnonymously();
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Failed to create anonymous user');
    }

    // Create a basic user model for anonymous users
    final user = UserModel(
      id: firebaseUser.uid,
      phone: null,
      email: firebaseUser.email,
      name: 'Anonymous User',
      profileImage: null,
      location: null,
      bio: null,
    );

    // Store anonymous user in local storage
    await _localStorage.insertUser(user);

    // Optionally store a flag indicating anonymous login
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_anonymous', true);

    return user;
  } catch (e) {
    throw Exception('Anonymous sign-in failed: ${e.toString()}');
  }
}
```

### Key Points:
- **Firebase UID**: Uses `firebaseUser.uid` as the user ID (anonymous users get unique Firebase UIDs)
- **User Model**: Creates a minimal `UserModel` with essential fields
- **Local Storage**: Stores the user in local SQLite database
- **Anonymous Flag**: Sets a preference flag to identify anonymous sessions

## Step 3: Update Your Sign-In UI

Add a button to your sign-in/login screen to allow anonymous access:

```dart
// Example in your sign-in screen widget
ElevatedButton(
  onPressed: () async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInAnonymously();
      
      // Navigate to home/main screen
      if (mounted) {
        context.go('/home'); // or your route
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  },
  child: const Text('Continue as Guest'),
)
```

## Step 4: Update Your AuthProvider (if using Provider)

If you're using a Provider/ChangeNotifier for state management, add:

```dart
Future<void> signInAnonymously() async {
  try {
    _user = await _authRepository.signInAnonymously();
    _isAuthenticated = true;
    notifyListeners();
  } catch (e) {
    _isAuthenticated = false;
    rethrow;
  }
}
```

## Step 5: Handle Anonymous User Upgrade

When an anonymous user wants to create a real account, upgrade their profile:

```dart
// Example: When user enters phone number
Future<void> upgradeAnonymousUser(String phone) async {
  try {
    // Link phone credential to anonymous account
    final credential = await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      // ... verification setup
    );
    
    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
    
    // Update user profile with phone
    await _authRepository.updateProfile({'phone': phone});
    
    // Clear anonymous flag
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_anonymous', false);
  } catch (e) {
    throw Exception('Failed to upgrade user: ${e.toString()}');
  }
}
```

## Step 6: Update Logout for Anonymous Users

The existing `logout()` method already handles anonymous sessions:

```dart
Future<void> logout() async {
  try {
    await _firebaseAuth.signOut(); // Works for both regular and anonymous users
    await _googleSignIn.signOut();
    await _secureStorage.delete(key: 'auth_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  } catch (e) {
    throw Exception('Logout failed: ${e.toString()}');
  }
}
```

## Step 7: Firebase Realtime Database/Firestore Rules

Update your Firebase security rules to allow anonymous users limited access:

### For Firestore:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anonymous users to read public data
    match /mechanics/{document=**} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth.uid == resource.data.uid;
    }
    
    // User profiles
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

### For Realtime Database:
```json
{
  "rules": {
    "mechanics": {
      ".read": "auth != null",
      ".write": "auth.uid === $.uid"
    },
    "users": {
      "$uid": {
        ".read": "auth != null",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

## Step 8: Environment Configuration

Add to your Firebase initialization in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Enable persistence for anonymous users
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  
  runApp(const MyApp());
}
```

## Step 9: Testing Anonymous Sign-In

1. Build and run your app: `flutter run`
2. Click the "Continue as Guest" button (once you add it to your UI)
3. Verify in Firebase Console → Authentication that a new anonymous user appears
4. Check local storage to confirm user is saved

## Step 10: Troubleshooting

### Issue: "Anonymous authentication is disabled"
- Go to Firebase Console
- Auth → Sign-in method → Ensure Anonymous is enabled

### Issue: "Permission denied" errors
- Check your Firestore/Database rules (Step 7)
- Ensure rules allow `request.auth != null` for anonymous users

### Issue: User data not persisting
- Check that `_localStorage.insertUser(user)` is working
- Verify your SQLite schema matches `UserModel`

## Production Checklist

- [ ] Enable Anonymous Auth in Firebase Console
- [ ] Update Firestore/Database security rules
- [ ] Add "Continue as Guest" button to sign-in screen
- [ ] Test anonymous user creation and persistence
- [ ] Test user upgrade from anonymous to authenticated
- [ ] Test logout for anonymous users
- [ ] Monitor anonymous user count in Firebase Analytics

## Related Documentation

- [Firebase Anonymous Auth Docs](https://firebase.google.com/docs/auth/flutter/anonymous-auth)
- [Flutter Firebase Auth Plugin](https://pub.dev/packages/firebase_auth)
- [Firebase Security Rules](https://firebase.google.com/docs/rules/rules-language)

---

**Next Steps:**
1. Run `flutter pub get` to ensure dependencies are installed
2. Go to your Firebase Console and enable Anonymous authentication
3. Add the "Continue as Guest" button to your sign-in screen
4. Test the anonymous sign-in flow
