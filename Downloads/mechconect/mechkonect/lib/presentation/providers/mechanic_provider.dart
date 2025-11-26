import 'package:flutter/foundation.dart';
import '../../data/models/mechanic_model.dart';
import '../../data/repositories/mechanic_repository.dart';

enum SortOption { nearest, topRated, cheapest }

class MechanicProvider with ChangeNotifier {
  final MechanicRepository _mechanicRepository;

  List<MechanicModel> _mechanics = [];
  MechanicModel? _selectedMechanic;
  bool _isLoading = false;
  String? _error;
  SortOption _sortOption = SortOption.nearest;
  String _searchQuery = '';

  MechanicProvider(this._mechanicRepository);

  List<MechanicModel> get mechanics => _getSortedMechanics();
  MechanicModel? get selectedMechanic => _selectedMechanic;
  bool get isLoading => _isLoading;
  String? get error => _error;
  SortOption get sortOption => _sortOption;
  String get searchQuery => _searchQuery;

  List<MechanicModel> _getSortedMechanics() {
    List<MechanicModel> filtered = _mechanics;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((mechanic) {
        final query = _searchQuery.toLowerCase();
        return mechanic.name.toLowerCase().contains(query) ||
            mechanic.workshopName?.toLowerCase().contains(query) == true ||
            mechanic.services.any((service) => service.toLowerCase().contains(query));
      }).toList();
    }

    // Apply sort
    switch (_sortOption) {
      case SortOption.nearest:
        return _mechanicRepository.sortByDistance(filtered);
      case SortOption.topRated:
        return _mechanicRepository.sortByRating(filtered);
      case SortOption.cheapest:
        return _mechanicRepository.sortByPrice(filtered);
    }
  }

  Future<void> loadNearbyMechanics({
    double? latitude,
    double? longitude,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _mechanics = await _mechanicRepository.getNearbyMechanics(
        latitude: latitude,
        longitude: longitude,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMechanics(String query) async {
    _searchQuery = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        await loadNearbyMechanics();
      } else {
        _mechanics = await _mechanicRepository.searchMechanics(query);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMechanic(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedMechanic = await _mechanicRepository.getMechanic(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

