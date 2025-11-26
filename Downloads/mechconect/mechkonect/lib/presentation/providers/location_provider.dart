import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService;

  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;
  String? _error;
  bool _locationPermissionGranted = false;

  LocationProvider(this._locationService);

  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get locationPermissionGranted => _locationPermissionGranted;

  Future<void> initializeLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _locationPermissionGranted = await _locationService.requestLocationPermission();
      if (!_locationPermissionGranted) {
        _error = 'Location permission denied';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final isEnabled = await _locationService.isLocationServiceEnabled();
      if (!isEnabled) {
        _error = 'Location services are disabled';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _currentPosition = await _locationService.getCurrentPosition();
      if (_currentPosition != null) {
        _currentAddress = await _locationService.getAddressFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      // Try to get last known position
      _currentPosition = await _locationService.getLastKnownPosition();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLocation() async {
    try {
      _currentPosition = await _locationService.getCurrentPosition();
      if (_currentPosition != null) {
        _currentAddress = await _locationService.getAddressFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void startLocationStream() {
    _locationService.getLocationStream().listen((position) {
      _currentPosition = position;
      _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      ).then((address) {
        _currentAddress = address;
        notifyListeners();
      });
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}




