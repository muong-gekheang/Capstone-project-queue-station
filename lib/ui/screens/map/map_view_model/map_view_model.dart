import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/location_service.dart';
import 'package:queue_station_app/services/route_service.dart';
import 'package:queue_station_app/utils/env.dart';
import 'package:queue_station_app/utils/map_maker_builder.dart';
import 'package:uuid/uuid.dart';

//test link to google
import 'package:url_launcher/url_launcher.dart';

class MapViewModel extends ChangeNotifier {
  // Repositories & Services
  final RestaurantRepository _repository;
  final LocationService _locationService = LocationService();
  late final RouteService _routeService;
  GoogleMapController? _mapController;

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
    required RestaurantRepository repository,
    String? ownRestaurantId,
    this.initialRestaurantId,
  }) : _repository = repository,
       _myStoreId = ownRestaurantId {
    _isStore = ownRestaurantId != null;
    _isStoreLocationSet = ownRestaurantId != null;
    _routeService = RouteService(Env.mapsKey);
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

  // --- INIT & MAP CONTROLLER & DATA FETCHING---
  void setPanelActive(bool active) {
    _isPanelActive = active;
    notifyListeners();
  }

  Future<void> initializeData() async {
    _allRestaurants = await _repository.getAllRestaurants();
    await _generateAllIcons();
    await locateUser();
  }

  Future<void> _refreshDataFromRepo() async {
    _allRestaurants = await _repository.getAllRestaurants();
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
    }
    _updateMarkers();
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
      // Generate new icons
      _iconCache['${myStore!.id}_unselected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            myStore!.name,
            myStore!.curWait,
            false,
            isOwner: true,
          );
      _iconCache['${myStore!.id}_selected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            myStore!.name,
            myStore!.curWait,
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
      _iconCache['${r.id}_unselected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            r.name,
            r.curWait,
            false,
            isOwner: false,
          );
      _iconCache['${r.id}_selected'] =
          await MarkerUtils.createCustomMarkerBitmap(
            r.name,
            r.curWait,
            true,
            isOwner: false,
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
      // ADD NEW
      final newStore = Restaurant(
        id: const Uuid().v4(),
        name: "My Store",
        location: center,
        address: "New Location",
        logoLink: "https://via.placeholder.com/150",
        biggestTableSize: 4,
        phone: "N/A",
        contactDetails: [],
        items: [],
        tables: [],
        globalAddOns: [],
        globalSizeOptions: [],
      );
      await _repository.addRestaurant(newStore);
      _myStoreId = newStore.id;
    } else {
      // UPDATE EXISTING
      final existingStore = myStore;
      if (existingStore != null) {
        existingStore.location = center;
        await _repository.updateRestaurant(existingStore);
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
    final target = getRestaurantById(restaurantId);
    if (target != null) {
      target.contactDetails = newAccounts;
      await _repository.updateRestaurant(target);
      notifyListeners();
    }
  }

  Future<void> updateMenuImages(
    String restaurantId,
    List<String> newImages,
  ) async {
    final target = getRestaurantById(restaurantId);
    if (target != null) {
      target.menuImageLinks = newImages;
      await _repository.updateRestaurant(target);
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
}
