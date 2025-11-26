import 'package:flutter/foundation.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

class BookingProvider with ChangeNotifier {
  final BookingRepository _bookingRepository;

  List<BookingModel> _bookings = [];
  BookingModel? _activeBooking;
  BookingModel? _selectedBooking;
  bool _isLoading = false;
  String? _error;

  BookingProvider(this._bookingRepository);

  List<BookingModel> get bookings => _bookings;
  BookingModel? get activeBooking => _activeBooking;
  BookingModel? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<BookingModel> get activeBookings => _bookings
      .where((b) => b.status != BookingStatus.completed &&
          b.status != BookingStatus.cancelled)
      .toList();

  List<BookingModel> get completedBookings => _bookings
      .where((b) => b.status == BookingStatus.completed)
      .toList();

  List<BookingModel> get cancelledBookings => _bookings
      .where((b) => b.status == BookingStatus.cancelled)
      .toList();

  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final booking = await _bookingRepository.createBooking(bookingData);
      _bookings.insert(0, booking);
      _activeBooking = booking;
      _error = null;
      return booking;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBookings({String? userId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookings = await _bookingRepository.getBookings(userId: userId);
      _activeBooking = activeBookings.isNotEmpty ? activeBookings.first : null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBooking(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedBooking = await _bookingRepository.getBooking(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _bookingRepository.updateBookingStatus(id, status);
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bookings[index] = updated;
      }
      if (_activeBooking?.id == id) {
        _activeBooking = updated.status == BookingStatus.completed ||
                updated.status == BookingStatus.cancelled
            ? null
            : updated;
      }
      if (_selectedBooking?.id == id) {
        _selectedBooking = updated;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> trackBooking(String id) async {
    try {
      return await _bookingRepository.trackBooking(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> cancelBooking(String id) async {
    await updateBookingStatus(id, BookingStatus.cancelled);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

