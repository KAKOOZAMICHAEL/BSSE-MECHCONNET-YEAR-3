import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/services/local_storage_service.dart';
import '../../providers/location_provider.dart';
import '../../providers/mechanic_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.initializeLocation();

    final mechanicProvider = Provider.of<MechanicProvider>(context, listen: false);
    await mechanicProvider.loadNearbyMechanics(
      latitude: locationProvider.currentPosition?.latitude,
      longitude: locationProvider.currentPosition?.longitude,
    );

    _updateMarkers();
    _animateToUserLocation();
  }

  void _updateMarkers() {
    final mechanicProvider = Provider.of<MechanicProvider>(context, listen: false);
    final mechanics = mechanicProvider.mechanics;

    setState(() {
      _markers.clear();

      // Add user location marker
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      if (locationProvider.currentPosition != null) {
        final pos = locationProvider.currentPosition!;
        _markers.add(
          Marker(
            point: LatLng(pos.latitude, pos.longitude),
            width: 40,
            height: 40,
            builder: (ctx) => const Icon(Icons.my_location, color: Colors.blue),
          ),
        );
      }

      // Add mechanic markers
      for (var mechanic in mechanics) {
        if (mechanic.latitude != null && mechanic.longitude != null) {
          _markers.add(
            Marker(
              point: LatLng(mechanic.latitude!, mechanic.longitude!),
              width: 48,
              height: 48,
              builder: (ctx) => GestureDetector(
                onTap: () => context.push('/mechanic/${mechanic.id}'),
                child: Container(
                  decoration: BoxDecoration(
                    color: mechanic.verified ? Colors.green : Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.build, color: Colors.white, size: 24),
                ),
              ),
            ),
          );
        }
      }
    });
  }

  void _animateToUserLocation() {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (locationProvider.currentPosition != null) {
      final pos = locationProvider.currentPosition!;
      _mapController.move(LatLng(pos.latitude, pos.longitude), 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final mechanicProvider = Provider.of<MechanicProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(
                locationProvider.currentPosition?.latitude ?? 0.0,
                locationProvider.currentPosition?.longitude ?? 0.0,
              ),
              zoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.mechkonect.app',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + AppDimensions.spacingMD,
            left: AppDimensions.spacingMD,
            right: AppDimensions.spacingMD,
            child: Card(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search mechanics...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Show filter bottom sheet
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppDimensions.spacingMD),
                ),
                onChanged: (value) {
                  mechanicProvider.searchMechanics(value);
                  _updateMarkers();
                },
              ),
            ),
          ),
          // SOS Button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppDimensions.spacingMD,
            right: AppDimensions.spacingMD,
            child: FloatingActionButton(
              heroTag: 'sos_fab',
              onPressed: () => context.push('/sos'),
              backgroundColor: AppColors.sosRed,
              child: const Icon(Icons.emergency, color: Colors.white),
              mini: true,
            ),
          ),
          // Bottom Sheet with Mechanics
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusXL),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingMD,
                      ),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(AppDimensions.spacingMD),
                        itemCount: mechanicProvider.mechanics.length,
                        itemBuilder: (context, index) {
                          final mechanic = mechanicProvider.mechanics[index];
                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: AppDimensions.spacingMD,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: mechanic.profilePictureUrl != null
                                    ? NetworkImage(mechanic.profilePictureUrl!)
                                    : null,
                                child: mechanic.profilePictureUrl == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(mechanic.name),
                              subtitle: Text(
                                '${mechanic.rating.toStringAsFixed(1)} ⭐ • ${mechanic.distance?.toStringAsFixed(1) ?? "N/A"} km away',
                              ),
                              trailing: mechanic.verified
                                  ? const Icon(Icons.verified, color: AppColors.success)
                                  : null,
                              onTap: () {
                                context.push('/mechanic/${mechanic.id}');
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Request Mechanic FAB
          Positioned(
            bottom: AppDimensions.spacingXL,
            right: AppDimensions.spacingMD,
            child: FloatingActionButton.extended(
              heroTag: 'request_fab',
              onPressed: () {
                // Always navigate to mechanics list, show snackbar if none available
                if (mechanicProvider.mechanics.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No mechanics available at this time. Try again later.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                context.push('/mechanics');
              },
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.build, color: Colors.white),
              label: const Text(
                'Request Mechanic',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Debug Re-Seed Button (only in debug mode)
          if (kDebugMode)
            Positioned(
              bottom: AppDimensions.spacingXL + 70,
              right: AppDimensions.spacingMD,
              child: FloatingActionButton(
                heroTag: 'debug_seed_fab',
                onPressed: () async {
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  try {
                    // Re-seed the database
                    await LocalStorageService().reseedDatabase();

                    // Reload mechanics
                    final mechanicProv =
                        Provider.of<MechanicProvider>(context, listen: false);
                    final locationProv =
                        Provider.of<LocationProvider>(context, listen: false);
                    await mechanicProv.loadNearbyMechanics(
                      latitude: locationProv.currentPosition?.latitude,
                      longitude: locationProv.currentPosition?.longitude,
                    );

                    // Close loading dialog
                    if (mounted) Navigator.of(context).pop();

                    // Show success message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Database re-seeded successfully! Found 10 mechanics.'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    // Close loading dialog
                    if (mounted) Navigator.of(context).pop();

                    // Show error message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error re-seeding: $e'),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                backgroundColor: Colors.orange,
                mini: true,
                tooltip: 'Re-seed Database (Debug)',
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

