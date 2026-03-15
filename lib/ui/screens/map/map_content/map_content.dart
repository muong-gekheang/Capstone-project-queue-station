import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/map/map_view_model/map_view_model.dart';
import 'package:queue_station_app/ui/widgets/restaurant_panel.dart';
import 'package:share_plus/share_plus.dart';

import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/widgets/map_contact_dialogs.dart';
import 'package:queue_station_app/ui/widgets/map_menu_dialog.dart';
import 'package:queue_station_app/ui/widgets/route_preview_panel.dart';

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  // Pure UI Animation State
  double _panelHeight = 0;
  final double _peekHeight = 250.0;
  late double _maxHeight;
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapViewModel>().initializeData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _closePanel(MapViewModel vm) {
    setState(() => _panelHeight = 0);
    vm.clearSelection();
  }

  void _openPanel() {
    setState(() => _panelHeight = _peekHeight);
  }

  // --- DIALOG LOGIC ---
  Future<void> _openContactEditor(
    MapViewModel vm,
    Restaurant restaurant,
  ) async {
    final ContactFormResult? result = await showDialog<ContactFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddContactDialog(
        initialAccounts: List<SocialAccount>.from(restaurant.contactDetails),
      ),
    );
    if (result != null) {
      vm.updateContactInfo(restaurant.id, result.socialAccounts);
    }
  }

  void _openContactDetailsOrEditor(MapViewModel vm, Restaurant restaurant) {
    if (restaurant.contactDetails.isEmpty &&
        vm.isStore &&
        vm.myStore?.id == restaurant.id) {
      _openContactEditor(vm, restaurant);
      return;
    }
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ContactDetailsDialog(
        socialAccounts: List<SocialAccount>.from(restaurant.contactDetails),
        onEdit: () {
          Navigator.pop(dialogContext);
          _openContactEditor(vm, restaurant);
        },
        onDelete: () {
          Navigator.pop(dialogContext);
          vm.updateContactInfo(restaurant.id, []);
        },
        isOwner: vm.isStore,
        isCurrentStore: vm.myStore?.id == restaurant.id,
      ),
    );
  }

  Future<void> _openMenuImageEditor(
    MapViewModel vm,
    Restaurant restaurant,
  ) async {
    final List<String>? updatedLinks = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddMenuImageDialog(
        initialImageLinks: List<String>.from(restaurant.menuImageLinks),
      ),
    );
    if (updatedLinks != null) vm.updateMenuImages(restaurant.id, updatedLinks);
  }

  void _triggerSetLocation(MapViewModel vm) async {
    bool? confirm = await _showCustomStyledDialog(
      title: !vm.isStoreLocationSet ? 'Set Location' : 'Update Location',
      message: !vm.isStoreLocationSet
          ? 'Are you sure you want to place your store marker here?'
          : 'Your existing marker will be moved to this new location.',
      confirmText: 'Confirm',
    );
    if (confirm == true) vm.confirmSetLocation(context);
  }

  void _triggerDeleteLocation(MapViewModel vm) async {
    bool? confirm = await _showCustomStyledDialog(
      title: 'Remove Marker',
      message:
          'This will hide your restaurant from the map. Are you sure you want to remove it?',
      confirmText: 'Remove',
      confirmColor: Colors.red,
    );
    if (confirm == true) {
      vm.deleteStoreLocation();
      _closePanel(vm);
    }
  }

  Future<bool?> _showCustomStyledDialog({
    required String title,
    required String message,
    required String confirmText,
    Color confirmColor = const Color(0xFF0D47A1),
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0D47A1), width: 2.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFF6835),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D47A1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFFF6835),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: Color(0xFF0D47A1), thickness: 2),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0D47A1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog(Restaurant restaurant) {
    final String deepLink = "queuestation://map?id=${restaurant.id}";
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0D47A1), width: 2.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Share",
                    style: TextStyle(
                      color: Color(0xFFFF6835),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D47A1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFFF6835),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: Color(0xFF0D47A1), thickness: 2),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            restaurant.logoLink,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 100,
                              width: 100,
                              color: const Color(0xFF0D47A1),
                              child: const Icon(
                                Icons.restaurant,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          restaurant.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            final String shareText =
                                'Check out ${restaurant.name} on Queue Station!\n$deepLink';
                            try {
                              await SharePlus.instance.share(
                                ShareParams(text: shareText),
                              );
                            } catch (e) {
                              await Clipboard.setData(
                                ClipboardData(text: shareText),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Link copied to clipboard: $deepLink',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D47A1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.ios_share,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Share location link",
                                  style: TextStyle(
                                    color: Color(0xFFFF6835),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: deepLink));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Link copied to clipboard: $deepLink',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D47A1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Copy location link",
                                  style: TextStyle(
                                    color: Color(0xFFFF6835),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Consumer<MapViewModel>(
      builder: (context, vm, child) {
        bool isMyStoreSelected =
            vm.isStore &&
            vm.selectedRestaurant != null &&
            vm.selectedRestaurant?.id == vm.myStore?.id;

        if (vm.selectedRestaurant != null && _panelHeight == 0) {
          _panelHeight = _peekHeight;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              vm.isStore ? "Store View" : "User View",
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              IconButton(
                onPressed: vm.toggleUserMode,
                icon: const Icon(Icons.swap_horiz),
              ),
              IconButton(
                onPressed: () {
                  vm.getDirectionsToRestaurant(vm.myStore!);
                },
                icon: const Icon(Icons.navigation),
              ),
            ],
          ),
          body: Stack(
            children: [
              IgnorePointer(
                ignoring: vm.isPanelActive,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(11.5564, 104.9282),
                    zoom: 14,
                  ),
                  onMapCreated: vm.onMapCreated,
                  onCameraMove: vm.onCameraMove,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  polylines: vm.polylines,
                  markers: vm.markers,
                  onTap: (latLng) {
                    if (vm.isPanelActive) {
                      _closePanel(vm);
                    }
                  },
                ),
              ),

              if (vm.selectedRestaurant != null)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      if (vm.isPanelActive) {
                        _closePanel(vm);
                      }
                    },
                    // child: Container(color: Colors.black.withOpacity(0.2)),
                    child: Container(color: Colors.transparent),
                  ),
                ),

              if (!vm.addingMode && vm.selectedRestaurant == null)
                Positioned(
                  top: 55,
                  left: 20,
                  right: 20,
                  child: SearchAnchor(
                    searchController: _searchController,
                    isFullScreen: false,
                    viewBackgroundColor: Colors.white,
                    viewSide: const BorderSide(color: Color(0xFF0D47A1)),
                    builder:
                        (BuildContext context, SearchController controller) {
                          return SearchBar(
                            controller: controller,
                            padding: const WidgetStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            backgroundColor:
                                const WidgetStatePropertyAll<Color>(
                                  Colors.white,
                                ),
                            elevation: const WidgetStatePropertyAll<double>(
                              8.0,
                            ),
                            hintText: "Search restaurants...",
                            leading: const Icon(
                              Icons.search,
                              color: Color(0xFFF05A28),
                            ),
                            onTap: () => controller.openView(),
                            onChanged: (_) => controller.openView(),
                            onSubmitted: (value) => vm.setSearchQuery(value),
                            trailing: <Widget>[
                              if (vm.searchQuery.isNotEmpty ||
                                  controller.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    controller.clear();
                                    vm.clearSearch();
                                  },
                                ),
                            ],
                          );
                        },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                          final String query = controller.text.toLowerCase();

                          if (query.isEmpty) {
                            return [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text("Enter to search restaurant"),
                                ),
                              ),
                            ];
                          }

                          final suggestions = vm.getFilteredSuggestions(query);

                          if (suggestions.isEmpty) {
                            return [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text("No restaurants found."),
                                ),
                              ),
                            ];
                          }

                          return suggestions.map((Restaurant r) {
                            return ListTile(
                              leading: const Icon(
                                Icons.location_on,
                                color: Color(0xFF0D47A1),
                              ),
                              title: Text(
                                r.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                r.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                controller.closeView(r.name);
                                vm.setSearchQuery(r.name);
                                vm.selectRestaurant(r);
                                _openPanel();
                              },
                            );
                          }).toList();
                        },
                  ),
                ),

              if (vm.addingMode)
                Center(
                  child: Icon(
                    Icons.add_location_alt_rounded,
                    color: vm.isStore ? const Color(0xFF0D47A1) : Colors.green,
                    size: 50,
                  ),
                ),

              if (vm.selectedRestaurant != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: _panelHeight,
                  child: Listener(
                    onPointerDown: (_) {
                      vm.setPanelActive(true);
                    },
                    onPointerUp: (_) {
                      vm.setPanelActive(false);
                    },
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (_) => vm.setPanelActive(true),
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          _panelHeight -= details.delta.dy;
                          if (_panelHeight > _maxHeight) {
                            _panelHeight = _maxHeight;
                          }
                          if (_panelHeight < 0) _panelHeight = 0;
                        });
                      },
                      onVerticalDragEnd: (_) {
                        setState(() {
                          vm.setPanelActive(false);
                          if (_panelHeight > _peekHeight + 100) {
                            _panelHeight = _maxHeight;
                          } else if (_panelHeight < 150) {
                            _closePanel(vm);
                          } else {
                            _panelHeight = _peekHeight;
                          }
                        });
                      },
                      onTap: () {},
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: _panelHeight < _maxHeight
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),

                          child: vm.routeDistance != null
                              ? RoutePreviewPanel(
                                  restaurant: vm.selectedRestaurant!,
                                  distance: vm.routeDistance!,
                                  onClose: () {
                                    vm.clearRoute();
                                    setState(() => _panelHeight = _peekHeight);
                                  },
                                )
                              : RestaurantPanel(
                                  restaurant: vm.selectedRestaurant!,
                                  isOwner: isMyStoreSelected,
                                  onClearSelection: () => _closePanel(vm),

                                  onDrawRoute: () {
                                    setState(() => _panelHeight = 250.0);
                                    vm.drawRoute(
                                      vm.selectedRestaurant!.location!,
                                    );
                                  },

                                  onContactTap: () =>
                                      _openContactDetailsOrEditor(
                                        vm,
                                        vm.selectedRestaurant!,
                                      ),
                                  onDeleteLocation: () =>
                                      _triggerDeleteLocation(vm),
                                  onEditLocation: () {
                                    _closePanel(vm);
                                    vm.setAddingMode(true);
                                  },
                                  onShareTap: () =>
                                      _showShareDialog(vm.selectedRestaurant!),
                                  onEditMenuTap: () => _openMenuImageEditor(
                                    vm,
                                    vm.selectedRestaurant!,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: vm.selectedRestaurant == null
              ? vm.addingMode
                    ? Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () => vm.setAddingMode(false),
                              label: const Text("Cancel"),
                              icon: const Icon(Icons.close),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.redAccent,
                            ),
                            const SizedBox(width: 10),
                            FloatingActionButton.extended(
                              onPressed: () => _triggerSetLocation(vm),
                              label: const Text("Confirm"),
                              icon: const Icon(Icons.check),
                              backgroundColor: vm.isStore
                                  ? const Color(0xFF0D47A1)
                                  : const Color(0xFFFF6835),
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            onPressed: vm.locateUser,
                            foregroundColor: const Color(0xFF0D47A1),
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.my_location),
                          ),
                          const SizedBox(height: 12),
                          if (vm.isStore)
                            FloatingActionButton(
                              backgroundColor: const Color(0xFF0D47A1),
                              onPressed: () => setState(() {
                                _searchController.clear();
                                vm.clearSearch();
                                // Check if the marker is set
                                if (!vm.isStoreLocationSet) {
                                  vm.setAddingMode(true);
                                } else {
                                  vm.selectRestaurant(vm.myStore);
                                  _openPanel();
                                }
                              }),
                              child: Icon(
                                !vm.isStoreLocationSet
                                    ? Icons.add_location_alt
                                    : Symbols.home_pin_rounded,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
