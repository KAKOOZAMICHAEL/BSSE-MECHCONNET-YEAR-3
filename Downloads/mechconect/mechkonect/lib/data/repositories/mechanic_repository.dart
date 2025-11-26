import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/location_service.dart';
import '../models/mechanic_model.dart';

class MechanicRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorage;
  final LocationService _locationService;

  MechanicRepository({
    required ApiService apiService,
    required LocalStorageService localStorage,
    required LocationService locationService,
  })  : _apiService = apiService,
        _localStorage = localStorage,
        _locationService = locationService;

  // Get nearby mechanics
  Future<List<MechanicModel>> getNearbyMechanics({
    double? latitude,
    double? longitude,
    double radius = 10.0,
  }) async {
    try {
      // Get current location if not provided
      Position? position;
      if (latitude == null || longitude == null) {
        position = await _locationService.getCurrentPosition();
        if (position == null) {
          // Return cached mechanics if location unavailable
          return await _localStorage.getMechanics();
        }
        latitude = position.latitude;
        longitude = position.longitude;
      }

      // For development: Always use local/cached mechanics to avoid API errors
      final cached = await _localStorage.getMechanics();
      if (cached.isNotEmpty) {
        return _calculateDistances(cached, latitude!, longitude!);
      }

      // If no cached data, return empty list
      return [];
    } catch (e) {
      print('Error loading mechanics: $e');
      // Return cached on error
      final cached = await _localStorage.getMechanics();
      if (cached.isNotEmpty) {
        final position = await _locationService.getCurrentPosition();
        if (position != null) {
          return _calculateDistances(
            cached,
            position.latitude,
            position.longitude,
          );
        }
      }
      return cached;
    }
  }

  // Get mechanic by ID
  Future<MechanicModel?> getMechanic(String id) async {
    try {
      // Always use local storage first for development
      final localMechanic = await _localStorage.getMechanic(id);
      return localMechanic;
    } catch (e) {
      print('Error getting mechanic: $e');
      return await _localStorage.getMechanic(id);
    }
  }

  // Search mechanics
  Future<List<MechanicModel>> searchMechanics(String query) async {
    try {
      // Use local storage for development
      return await _localStorage.searchMechanics(query);
    } catch (e) {
      print('Error searching mechanics: $e');
      return await _localStorage.searchMechanics(query);
    }
  }

  // Get all mechanics
  Future<List<MechanicModel>> getAllMechanics({
    int? limit,
    int? offset,
  }) async {
    try {
      // Use local storage for development
      return await _localStorage.getMechanics(limit: limit, offset: offset);
    } catch (e) {
      print('Error getting all mechanics: $e');
      return await _localStorage.getMechanics(limit: limit, offset: offset);
    }
  }

  // Calculate distances for mechanics
  List<MechanicModel> _calculateDistances(
    List<MechanicModel> mechanics,
    double userLat,
    double userLon,
  ) {
    return mechanics.map((mechanic) {
      if (mechanic.latitude != null && mechanic.longitude != null) {
        final distance = _locationService.calculateDistance(
          userLat,
          userLon,
          mechanic.latitude!,
          mechanic.longitude!,
        );
        return mechanic.copyWith(distance: distance);
      }
      return mechanic;
    }).toList();
  }

  // Sort mechanics by distance
  List<MechanicModel> sortByDistance(List<MechanicModel> mechanics) {
    final sorted = List<MechanicModel>.from(mechanics);
    sorted.sort((a, b) {
      final distA = a.distance ?? double.infinity;
      final distB = b.distance ?? double.infinity;
      return distA.compareTo(distB);
    });
    return sorted;
  }

  // Sort mechanics by rating
  List<MechanicModel> sortByRating(List<MechanicModel> mechanics) {
    final sorted = List<MechanicModel>.from(mechanics);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  // Sort mechanics by price (lowest first)
  List<MechanicModel> sortByPrice(List<MechanicModel> mechanics) {
    final sorted = List<MechanicModel>.from(mechanics);
    sorted.sort((a, b) {
      // Extract price from price range string
      final priceA = _extractMinPrice(a.priceRange);
      final priceB = _extractMinPrice(b.priceRange);
      return priceA.compareTo(priceB);
    });
    return sorted;
  }

  double _extractMinPrice(String? priceRange) {
    if (priceRange == null) return double.infinity;
    final match = RegExp(r'(\d+)').firstMatch(priceRange);
    if (match != null) {
      return double.parse(match.group(1)!);
    }
    return double.infinity;
  }
}