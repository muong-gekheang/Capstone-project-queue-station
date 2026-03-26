import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:queue_station_app/data/repositories/map/map_repository.dart';
import 'package:queue_station_app/data/repositories/map/social/social_account_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/ui/screens/map/services/storage_service.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/restaurant/restaurant_social.dart';
import 'package:queue_station_app/ui/screens/map/services/location_service.dart';
import 'package:queue_station_app/ui/screens/map/services/route_service.dart';
import 'package:queue_station_app/ui/screens/map/utils/env.dart';
import 'package:queue_station_app/ui/screens/map/utils/map_maker_builder.dart';
import 'package:uuid/uuid.dart';

//test link to google
import 'package:url_launcher/url_launcher.dart';

class MapViewModel extends ChangeNotifier {
  // Repositories & Services
  final MapRepository _repository;
  final SocialAccountRepository _socialRepository;
  // --- 1. ADD THE QUEUE REPOSITORY ---
  final QueueEntryRepository _queueRepo;
  final LocationService _locationService = LocationService();
  late final RouteService _routeService;
  GoogleMapController? _mapController;

  // Track active queue streams for visible markers
  final Map<String, StreamSubscription<List<QueueEntry>>> _activeQueueStreams =
      {};
  // Track the actual live queue counts for visible markers
  final Map<String, int> _liveQueueCounts = {};

  //Data Stream
  StreamSubscription<List<Restaurant>>? _restaurantSubscription;

  // Data State
  List<Restaurant> _allRestaurants = [];
  String? _myStoreId;
  final String? initialRestaurantId;

  // App State
  bool _isStore = true;
  bool _isStoreLocationSet = false;
  bool _addingMode = false;
  String _searchQuery = '';
  Restaurant? _selectedRestaurant;
  LatLng? _userLocation;

  bool _isPanelActive = false;
  bool get isPanelActive => _isPanelActive;

  // Map Rendering State
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _showMarkers = true;
  final double _zoomThreshold = 13.5;
  final Map<String, BitmapDescriptor> _iconCache = {};
  BitmapDescriptor? _userLocationIcon;
  String? _routeDistance;
  String? get routeDistance => _routeDistance;

  // --- CONSTRUCTOR ---
  MapViewModel({
    required MapRepository repository,
    required SocialAccountRepository socialRepository,
    required QueueEntryRepository queueRepo,
    String? ownRestaurantId,
    this.initialRestaurantId,
  }) : _repository = repository,
       _socialRepository = socialRepository,
       _queueRepo = queueRepo,
       _myStoreId = ownRestaurantId {
    _isStore = ownRestaurantId != null;
    _isStoreLocationSet = false;
    _routeService = RouteService(Env.mapsKey);
  }

  //Dispose
  @override
  void dispose() {
    _restaurantSubscription?.cancel();
    _mapController?.dispose();
    _cancelAllQueueStreams();
    super.dispose();
  }

  // --- GETTERS ---
  bool get isStore => _isStore;
  bool get isStoreLocationSet => _isStoreLocationSet;
  bool get addingMode => _addingMode;
  String get searchQuery => _searchQuery;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  LatLng? get userLocation => _userLocation;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  int getQueueForRestaurant(String restaurantId) {
    return _liveQueueCounts[restaurantId] ?? 0;
  }

  Restaurant? get myStore {
    if (_myStoreId == null) return null;
    try {
      return _allRestaurants.firstWhere((r) => r.id == _myStoreId);
    } catch (e) {
      return null;
    }
  }

  List<Restaurant> get allRestaurants {
    if (!_isStoreLocationSet && _myStoreId != null) {
      return _allRestaurants.where((r) => r.id != _myStoreId).toList();
    }
    return _allRestaurants;
  }

  List<Restaurant> get visibleRestaurants {
    return allRestaurants.where((r) => r.location != null).toList();
  }

  List<Restaurant> get filteredRestaurants {
    if (_searchQuery.isEmpty) return allRestaurants;
    final query = _searchQuery.toLowerCase();
    return allRestaurants.where((r) {
      return r.name.toLowerCase().contains(query) ||
          r.address.toLowerCase().contains(query);
    }).toList();
  }

  Restaurant? getRestaurantById(String id) {
    try {
      return _allRestaurants.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Restaurant> getFilteredSuggestions(String query) {
    final q = query.toLowerCase();
    return visibleRestaurants
        .where(
          (r) =>
              r.name.toLowerCase().contains(q) ||
              r.address.toLowerCase().contains(q),
        )
        .toList();
  }

  void _checkStoreLocationStatus() {
    if (_myStoreId != null) {
      final store = myStore;
      _isStoreLocationSet = (store != null && store.location != null);
    }
  }

  // --- INIT & MAP CONTROLLER & DATA FETCHING---
  void setPanelActive(bool active) {
    _isPanelActive = active;
    notifyListeners();
  }

  Future<void> initializeData() async {
    // Start listening to Firebase in real-time!
    _restaurantSubscription = _repository.getRestaurantsStream().listen((
      restaurants,
    ) async {
      _allRestaurants = restaurants;

      _checkStoreLocationStatus();

      // If a user is currently looking at a restaurant panel, we MUST update
      // the selected object so the UI instantly shows the new menu images!
      if (_selectedRestaurant != null) {
        try {
          _selectedRestaurant = _allRestaurants.firstWhere(
            (r) => r.id == _selectedRestaurant!.id,
          );
        } catch (e) {
          _selectedRestaurant = null;
        }
      }

      await _generateAllIcons();
      notifyListeners();
    });

    await locateUser();
  }

  Future<void> _refreshDataFromRepo() async {
    _allRestaurants = await _repository.getAllRestaurants();
    _checkStoreLocationStatus();
    await _generateAllIcons();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (initialRestaurantId != null) {
      _focusOnRestaurantById(initialRestaurantId!);
    }
  }

  void onCameraMove(CameraPosition position) {
    bool shouldShow = position.zoom >= _zoomThreshold;
    if (_showMarkers != shouldShow) {
      _showMarkers = shouldShow;
      _updateMarkers();
    }
  }

  // --- CORE LOGIC ---
  void toggleUserMode() {
    _isStore = !_isStore;
    clearSelection();
  }

  void setAddingMode(bool val) {
    _addingMode = val;
    if (val) _selectedRestaurant = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _updateMarkers();
  }

  void clearSearch() {
    _searchQuery = '';
    _updateMarkers();
  }

  void selectRestaurant(Restaurant? r) {
    _selectedRestaurant = r;
    _addingMode = false;
    _polylines.clear();

    if (r != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(r.location!, 16),
      );

      _updateMarkers();
    }
  }

  void clearSelection() {
    _selectedRestaurant = null;
    _polylines.clear();
    _routeDistance = null;
    _updateMarkers();
  }

  void clearRoute() {
    _polylines.clear();
    _routeDistance = null;
    notifyListeners();
  }

  // --- ACTIONS ---
  Future<void> locateUser() async {
    _userLocation = await _locationService.getUserLocation();
    if (_userLocation != null && initialRestaurantId == null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_userLocation!, 15),
      );
    }
    _updateMarkers();
  }

  void _focusOnRestaurantById(String id) {
    final cleanId = id.trim();
    try {
      final target = allRestaurants.firstWhere((r) => r.id == cleanId);
      Future.delayed(
        const Duration(milliseconds: 300),
        () => selectRestaurant(target),
      );
    } catch (e) {
      debugPrint("Deep Link Error: ID $cleanId not found");
    }
  }

  Future<void> drawRoute(LatLng destination) async {
    _routeDistance = "Calculating...";
    notifyListeners();

    if (_userLocation == null) {
      try {
        _userLocation = await _locationService.getUserLocation();
      } catch (e) {
        _routeDistance = "Failed";
        notifyListeners();
        return;
      }
    }

    if (_userLocation == null) {
      _routeDistance = "Failed";
      notifyListeners();
      return;
    }

    final routeData = await _routeService.getRouteData(
      _userLocation!,
      destination,
    );

    if (routeData != null && routeData.points.isNotEmpty) {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          width: 5,
          color: const Color(0xFF0D47A1),
          points: routeData.points,
        ),
      );

      double km = routeData.distanceMeters / 1000;
      _routeDistance = "${km.toStringAsFixed(1)}Km";

      double minLat = routeData.points.first.latitude,
          minLng = routeData.points.first.longitude;
      double maxLat = routeData.points.first.latitude,
          maxLng = routeData.points.first.longitude;
      for (var p in routeData.points) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          50,
        ),
      );

      notifyListeners();
    } else {
      _routeDistance = "No route found";
      notifyListeners();
    }
  }

  Future<void> _updateMyStoreIcon() async {
    if (myStore == null) return;

    if (_isStoreLocationSet) {
      final queue = _liveQueueCounts[myStore!.id];
      _iconCache['${myStore!.id}_unselected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            myStore!.name,
            queue ?? -1,
            false,
            isOwner: true,
          );
      _iconCache['${myStore!.id}_selected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            myStore!.name,
            queue ?? -1,
            true,
            isOwner: true,
          );
    } else {
      // CLEANUP: If location is NOT set, remove old icons from cache
      _iconCache.remove('${myStore!.id}_unselected');
      _iconCache.remove('${myStore!.id}_selected');
    }
  }

  // --- MARKER GENERATION ---
  Future<void> _generateAllIcons() async {
    for (var r in _allRestaurants) {
      final queue = _liveQueueCounts[r.id];
      _iconCache['${r.id}_unselected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            r.name,
            queue ?? -1,
            false,
            isOwner: false,
          );
      _iconCache['${r.id}_selected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            r.name,
            queue ?? -1,
            true,
            isOwner: false,
          );
    }

    if (myStore != null && _isStoreLocationSet) {
      _iconCache['${myStore!.id}_unselected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            myStore!.name,
            0,
            false,
            isOwner: true,
          );
      _iconCache['${myStore!.id}_selected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            myStore!.name,
            0,
            true,
            isOwner: true,
          );
    }

    await _updateMyStoreIcon();

    _userLocationIcon = await MarkerUtils.createUserLocationBitmap();
    _updateMarkers();
  }

  void _updateMarkers() {
    Set<Marker> newMarkers = {};
    if (_showMarkers) {
      for (var r in filteredRestaurants) {
        if (r.location == null) continue;
        bool isSelected = _selectedRestaurant?.id == r.id;
        BitmapDescriptor? icon =
            _iconCache['${r.id}_${isSelected ? "selected" : "unselected"}'];
        if (icon != null) {
          newMarkers.add(
            Marker(
              markerId: MarkerId(r.id),
              position: r.location!,
              icon: icon,
              anchor: const Offset(0.5, 1.0),
              zIndex: isSelected ? 2.0 : 1.0,
              clusterManagerId: const ClusterManagerId('restaurant_cluster'),
              onTap: () => selectRestaurant(r),
            ),
          );
        }
      }
    }
    if (_userLocation != null && _userLocationIcon != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('user_loc'),
          position: _userLocation!,
          icon: _userLocationIcon!,
          anchor: const Offset(0.5, 0.5),
          zIndex: 3.0,
        ),
      );
    }
    _markers = newMarkers;
    notifyListeners();
  }

  // --- CRUD OPERATIONS USING REPOSITORY ---
  Future<void> confirmSetLocation(BuildContext context) async {
    if (_mapController == null) return;
    LatLng center = await _mapController!.getLatLng(
      ScreenCoordinate(
        x: (MediaQuery.of(context).size.width / 2).round(),
        y: (MediaQuery.of(context).size.height / 2).round(),
      ),
    );

    if (_myStoreId == null) {
      //! unesscessary (for testing only)
      // ADD NEW
      final newStore = Restaurant(
        id: const Uuid().v4(),
        name: "My Store",
        location: center,
        address: "New Location",
        logoLink: "https://via.placeholder.com/150",
        biggestTableSize: 4,
        phone: "N/A",
        openingTime: 480, // e.g., 8:00 AM (8 * 60)
        closingTime: 1260, // e.g., 9:00 PM (21 * 60)
        subscriptionDate: DateTime.now(),
        contactDetailIds: [],
        menuImageLinks: [],
      );
      await _repository.addRestaurant(newStore);
      _myStoreId = newStore.id;
      //!==========================
    } else {
      // UPDATE EXISTING
      final existingStore = myStore;
      if (existingStore != null) {
        final updatedStore = existingStore.copyWith(location: center);

        final index = _allRestaurants.indexWhere((r) => r.id == _myStoreId);
        if (index != -1) _allRestaurants[index] = updatedStore;
        await _repository.updateRestaurant(updatedStore);
      }
    }

    _isStoreLocationSet = true;
    _addingMode = false;
    await _refreshDataFromRepo();
  }

  Future<void> deleteStoreLocation() async {
    if (_myStoreId != null) {
      await _repository.deleteRestaurantLocation(_myStoreId!);
      _isStoreLocationSet = false;
      clearSelection();
      await _updateMyStoreIcon();
      await _refreshDataFromRepo();
      _updateMarkers();
    }
  }

  Future<void> updateContactInfo(
    String restaurantId,
    List<SocialAccount> newAccounts,
  ) async {
    final targetIndex = _allRestaurants.indexWhere((r) => r.id == restaurantId);
    if (targetIndex != -1) {
      List<String> newIds = [];
      for (var account in newAccounts) {
        await _socialRepository.saveAccount(account);
        newIds.add(account.id);
      }

      final updatedRestaurant = _allRestaurants[targetIndex].copyWith(
        contactDetailIds: newIds,
      );

      _allRestaurants[targetIndex] = updatedRestaurant;
      await _repository.updateRestaurant(updatedRestaurant);

      notifyListeners();
    }
  }

  Future<List<SocialAccount>> getRealSocialAccounts(
    List<String> contactIds,
  ) async {
    if (contactIds.isEmpty) return [];
    return await _socialRepository.getAccountsByIds(contactIds);
  }

  Future<void> updateMenuImages(
    String restaurantId,
    List<String> newImagePaths,
  ) async {
    final targetIndex = _allRestaurants.indexWhere((r) => r.id == restaurantId);

    if (targetIndex != -1) {
      // Get the old list of images before we change anything
      final List<String> oldImages =
          _allRestaurants[targetIndex].menuImageLinks;

      // Separate the new list into "Already Uploaded (http)" and "New Local Files"
      final List<String> keptHttpLinks = newImagePaths
          .where((link) => link.startsWith('http'))
          .toList();
      final List<String> newLocalFiles = newImagePaths
          .where((link) => !link.startsWith('http'))
          .toList();

      // Find which images were DELETED by the user
      // (If it was in oldImages, but is NOT in keptHttpLinks, the user deleted it!)
      final List<String> deletedLinks = oldImages
          .where((oldLink) => !keptHttpLinks.contains(oldLink))
          .toList();

      // Actually DELETE them from Firebase Storage
      for (String deletedLink in deletedLinks) {
        await StorageService.deleteImage(deletedLink);
      }

      // UPLOAD the new local files
      List<String> finalUrls = [...keptHttpLinks];

      for (String path in newLocalFiles) {
        try {
          String downloadUrl = await StorageService.uploadMenuImage(
            restaurantId,
            path,
          );
          finalUrls.add(downloadUrl);
        } catch (e) {
          print("Failed to upload new image: $path");
          print(e);
        }
      }

      // UPDATE the Restaurant object using copyWith
      final updatedRestaurant = _allRestaurants[targetIndex].copyWith(
        menuImageLinks: finalUrls,
      );

      // Save to local list and Firebase Firestore!
      _allRestaurants[targetIndex] = updatedRestaurant;
      await _repository.updateRestaurant(updatedRestaurant);

      notifyListeners();
    }
  }

  //test link to google
  Future<void> openPreciseDirections({
    required double userLat,
    required double userLng,
    required double destLat,
    required double destLng,
  }) async {
    final String url =
        'https://www.google.com/maps/dir/?api=1'
        '&origin=$userLat,$userLng'
        '&destination=$destLat,$destLng'
        '&travelmode=driving';

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch maps');
    }
  }

  Future<void> getDirectionsToRestaurant(Restaurant restaurant) async {
    // Position position = await Geolocator.getCurrentPosition();

    // Launch Google Maps with BOTH coordinates
    await openPreciseDirections(
      userLat: _userLocation!.latitude,
      userLng: _userLocation!.longitude,
      destLat: restaurant.location!.latitude,
      destLng: restaurant.location!.longitude,
    );
  }

  Future<void> onCameraIdle(BuildContext context) async {
    if (_mapController == null) return;

    // 1. Get current zoom level and screen bounds
    final zoomLevel = await _mapController!.getZoomLevel();

    // Safety check: If zoomed out too far, cancel ALL queue streams to save money.
    // The user just sees Clusters anyway!
    if (zoomLevel < _zoomThreshold) {
      _cancelAllQueueStreams();
      return;
    }

    // 2. Get the LatLng Box of the current screen
    final LatLngBounds bounds = await _mapController!.getVisibleRegion();

    // 3. Find which restaurants are inside this box
    final List<Restaurant> visibleRestaurants = filteredRestaurants.where((r) {
      if (r.location == null) return false;
      return bounds.contains(r.location!);
    }).toList();

    final Set<String> visibleIds = visibleRestaurants.map((r) => r.id).toSet();

    // 4. CANCEL streams for restaurants that are no longer on the screen
    _activeQueueStreams.removeWhere((id, subscription) {
      if (!visibleIds.contains(id)) {
        print("Cancelling stream for restaurantId: $id");
        subscription.cancel(); // Kill the Firebase stream
        _liveQueueCounts.remove(id); // Clear the local count
        return true; // Remove from active map
      }
      return false;
    });

    // 5. START streams for new restaurants that just entered the screen
    for (var r in visibleRestaurants) {
      if (!_activeQueueStreams.containsKey(r.id)) {
        // Open a new stream!
        _activeQueueStreams[r.id] = _queueRepo
            .watchCurrentActiveQueue(r.id)
            .listen((entries) async {
              print("🔴 Stream fired for: ${r.id}");
              // Store the live count
              _liveQueueCounts[r.id] = entries.length;

              // Re-draw just this specific marker with its new number!
              await _updateSingleMarkerIcon(r, entries.length);
            });
      }
    }
  }

  void _cancelAllQueueStreams() {
    for (var sub in _activeQueueStreams.values) {
      print("❌ Cancelling stream for restaurantId: ");
      sub.cancel();
    }
    _activeQueueStreams.clear();
    _liveQueueCounts.clear();

    print("After cancel: ${_activeQueueStreams.length} active streams");
    print("Live queue counts cleared: ${_liveQueueCounts.isEmpty}");
  }

  Future<void> _updateSingleMarkerIcon(Restaurant r, int queueWait) async {
    bool isOwner = r.id == _myStoreId;
    bool isSelected = _selectedRestaurant?.id == r.id;

    // Generate the new graphic with "6Q" or "7Q"
    _iconCache['${r.id}_unselected'] =
        await MarkerUtils.createCustomMarkerBitmap(
          r.name,
          queueWait,
          false,
          isOwner: isOwner,
        );
    _iconCache['${r.id}_selected'] = await MarkerUtils.createCustomMarkerBitmap(
      r.name,
      queueWait,
      true,
      isOwner: isOwner,
    );

    // Refresh the map markers
    _updateMarkers();
  }

  // Handle Zooming when a user clicks a cluster
  Future<void> zoomToCluster(LatLng position) async {
    if (_mapController == null) return;

    final currentZoom = await _mapController!.getZoomLevel();
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(position, currentZoom + 2),
    );
  }
}
