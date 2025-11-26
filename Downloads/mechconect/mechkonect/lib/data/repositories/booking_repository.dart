import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorage;

  BookingRepository({
    required ApiService apiService,
    required LocalStorageService localStorage,
  })  : _apiService = apiService,
        _localStorage = localStorage;

  // Create booking
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    try {
      // Create local booking - don't attempt API call to avoid backend errors
      final booking = BookingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: bookingData['user_id'] as String,
        mechanicId: bookingData['mechanic_id'] as String,
        mechanicName: bookingData['mechanic_name'] as String?,
        mechanicPhone: bookingData['mechanic_phone'] as String?,
        serviceType: ServiceType.values.firstWhere(
          (e) => e.name == bookingData['service_type'],
          orElse: () => ServiceType.minor,
        ),
        vehicleModel: bookingData['vehicle_model'] as String?,
        specialInstructions: bookingData['special_instructions'] as String?,
        cost: bookingData['cost'] as double?,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        scheduledTime: bookingData['scheduled_time'] != null
            ? DateTime.parse(bookingData['scheduled_time'])
            : null,
        userLatitude: bookingData['user_latitude'] as double?,
        userLongitude: bookingData['user_longitude'] as double?,
        userAddress: bookingData['user_address'] as String?,
        diagnosticAnswers: bookingData['diagnostic_answers'] as Map<String, dynamic>?,
      );
      await _localStorage.insertBooking(booking);
      return booking;
    } catch (e) {
      throw Exception('Failed to create booking: ${e.toString()}');
    }
  }

  // Get bookings
  Future<List<BookingModel>> getBookings({
    String? userId,
    BookingStatus? status,
  }) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return await _localStorage.getBookings(userId: userId, status: status);
      }

      // Fetch from API
      final bookings = await _apiService.getBookings({
        if (userId != null) 'user_id': userId,
        if (status != null) 'status': status.name,
      });

      // Cache bookings
      for (final booking in bookings) {
        await _localStorage.insertBooking(booking);
      }

      return bookings;
    } catch (e) {
      return await _localStorage.getBookings(userId: userId, status: status);
    }
  }

  // Get booking by ID
  Future<BookingModel?> getBooking(String id) async {
    try {
      final localBooking = await _localStorage.getBooking(id);
      
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return localBooking;
      }

      try {
        final booking = await _apiService.getBooking(id);
        await _localStorage.insertBooking(booking);
        return booking;
      } catch (e) {
        return localBooking;
      }
    } catch (e) {
      return await _localStorage.getBooking(id);
    }
  }

  // Update booking status
  Future<BookingModel> updateBookingStatus(
    String id,
    BookingStatus status,
  ) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      
      BookingModel updatedBooking;
      if (connectivityResult == ConnectivityResult.none) {
        // Update locally
        final booking = await _localStorage.getBooking(id);
        if (booking == null) {
          throw Exception('Booking not found');
        }
        updatedBooking = booking.copyWith(status: status);
        await _localStorage.updateBooking(updatedBooking);
      } else {
        // Update via API
        final response = await _apiService.updateBookingStatus(id, {
          'status': status.name,
        });
        updatedBooking = response;
        await _localStorage.updateBooking(updatedBooking);
      }

      return updatedBooking;
    } catch (e) {
      throw Exception('Failed to update booking: ${e.toString()}');
    }
  }

  // Track booking (get mechanic location)
  Future<Map<String, dynamic>> trackBooking(String id) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      return await _apiService.trackBooking(id);
    } catch (e) {
      throw Exception('Failed to track booking: ${e.toString()}');
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String id) async {
    await updateBookingStatus(id, BookingStatus.cancelled);
  }
}

