import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/registration_screen.dart';
import '../presentation/screens/auth/otp_verification_screen.dart';
import '../presentation/screens/home/map_screen.dart';
import '../presentation/screens/mechanic/mechanic_list_screen.dart';
import '../presentation/screens/mechanic/mechanic_detail_screen.dart';
import '../presentation/screens/booking/booking_form_screen.dart';
import '../presentation/screens/booking/booking_history_screen.dart';
import '../presentation/screens/payment/wallet_screen.dart';
import '../presentation/screens/payment/payment_confirmation_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/emergency/sos_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/mechanics',
        name: 'mechanics',
        builder: (context, state) => const MechanicListScreen(),
      ),
      GoRoute(
        path: '/mechanic/:id',
        name: 'mechanic-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MechanicDetailScreen(mechanicId: id);
        },
      ),
      GoRoute(
        path: '/booking/:mechanicId',
        name: 'booking',
        builder: (context, state) {
          final mechanicId = state.pathParameters['mechanicId']!;
          return BookingFormScreen(mechanicId: mechanicId);
        },
      ),
      GoRoute(
        path: '/booking-history',
        name: 'booking-history',
        builder: (context, state) => const BookingHistoryScreen(),
      ),
      GoRoute(
        path: '/wallet',
        name: 'wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/payment/:bookingId',
        name: 'payment',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return PaymentConfirmationScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/sos',
        name: 'sos',
        builder: (context, state) => const SosScreen(),
      ),
    ],
  );
}

