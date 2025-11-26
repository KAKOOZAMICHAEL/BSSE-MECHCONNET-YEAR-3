import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorage;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepository({
    required ApiService apiService,
    required LocalStorageService localStorage,
  })  : _apiService = apiService,
        _localStorage = localStorage;

  // Phone number login (sends OTP)
  Future<void> loginWithPhone(String phone) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('verification_id', verificationId);
          if (resendToken != null) {
            await prefs.setInt('resend_token', resendToken);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  // Verify OTP - Accept any 6 digits
  Future<UserModel> verifyOtp(String otp) async {
    if (otp.length != 6 || int.tryParse(otp) == null) {
      throw Exception('OTP must be any 6 digits');
    }
    
    // Create a test user for demo
    final user = UserModel(
      id: 'test-user-id',
      username: 'TestUser',
      phone: '256759371975',
      email: null,
      nin: 'CF1234567890AB',
      permitNumber: 'PERMIT2025A',
      dateOfBirth: null,
      gender: 'male',
      profilePictureUrl: null,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
    
    await _localStorage.insertUser(user);
    await _secureStorage.write(key: 'auth_token', value: 'dummy-token');
    return user;
  }

  // Anonymous Sign-In - Always succeeds
  Future<UserModel> signInAnonymously() async {
    final user = UserModel(
      id: 'anonymous-user-${DateTime.now().millisecondsSinceEpoch}',
      username: 'Anonymous',
      phone: '',
      email: null,
      nin: 'CF1234567890AB',
      permitNumber: 'PERMIT2025A',
      dateOfBirth: null,
      gender: 'male',
      profilePictureUrl: null,
      createdAt: DateTime.now(),
      updatedAt: null,
    );

    await _localStorage.insertUser(user);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_anonymous', true);
    return user;
  }

  // Google Sign-In
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      // Call backend
      final response = await _apiService.googleSignIn({
        'idToken': idToken,
        'email': googleUser.email,
        'name': googleUser.displayName,
      });

      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final token = response['token'] as String;

      await _secureStorage.write(key: 'auth_token', value: token);
      await _localStorage.insertUser(user);

      return user;
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  // Register new user
  Future<UserModel> register(Map<String, dynamic> userData) async {
    try {
      final user = await _apiService.register(userData);
      await _localStorage.insertUser(user);
      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> userData) async {
    try {
      final user = await _apiService.updateProfile(userData);
      await _localStorage.insertUser(user);
      return user;
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      return token != null;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final phone = firebaseUser.phoneNumber;
      if (phone == null) return null;

      // Try to get from local storage first
      final localUser = await _localStorage.getUserByPhone(phone);
      if (localUser != null) return localUser;

      // Fetch from API
      return await _apiService.getUserProfile();
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _secureStorage.delete(key: 'auth_token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // Resend OTP
  Future<void> resendOtp(String phone) async {
    try {
      await loginWithPhone(phone);
    } catch (e) {
      throw Exception('Failed to resend OTP: ${e.toString()}');
    }
  }
}