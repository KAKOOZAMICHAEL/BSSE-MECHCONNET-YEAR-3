import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dark_theme.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/api_service.dart';
import 'data/services/location_service.dart';
import 'data/services/notification_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/mechanic_repository.dart';
import 'data/repositories/booking_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/mechanic_provider.dart';
import 'presentation/providers/booking_provider.dart';
import 'presentation/providers/location_provider.dart';
import 'presentation/providers/payment_provider.dart';
import 'routes/app_router.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue anyway - some features may work without full Firebase config
  }
  
  // Initialize services
  await LocalStorageService().database;
  await NotificationService().initialize();
  
  runApp(const MechKonectApp());
}

class MechKonectApp extends StatelessWidget {
  const MechKonectApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Dio
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.mechkonect.com/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // Initialize services
    final localStorage = LocalStorageService();
    final locationService = LocationService();
    final apiService = ApiService(dio);

    // Initialize repositories
    final authRepository = AuthRepository(
      apiService: apiService,
      localStorage: localStorage,
    );
    final mechanicRepository = MechanicRepository(
      apiService: apiService,
      localStorage: localStorage,
      locationService: locationService,
    );
    final bookingRepository = BookingRepository(
      apiService: apiService,
      localStorage: localStorage,
    );
    final paymentRepository = PaymentRepository(
      apiService: apiService,
      localStorage: localStorage,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(locationService),
        ),
        ChangeNotifierProvider(
          create: (_) => MechanicProvider(mechanicRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(bookingRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(paymentRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'MechKonect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: DarkTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

