import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/map/map_view_model/map_view_model.dart';
import 'package:queue_station_app/ui/screens/map/utils/map_dialog_helper.dart';
import 'package:queue_station_app/ui/screens/map/widgets/restaurant_panel.dart';

import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/screens/map/widgets/route_preview_panel.dart';

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

  void _triggerSetLocation(MapViewModel vm) async {
    bool? confirm = await MapDialogHelper.showCustomStyledDialog(
      context: context,
      title: !vm.isStoreLocationSet ? 'Set Location' : 'Update Location',
      message: !vm.isStoreLocationSet
          ? 'Are you sure you want to place your store marker here?'
          : 'Your existing marker will be moved to this new location.',
      confirmText: 'Confirm',
    );
    if (confirm == true) vm.confirmSetLocation(context);
  }

  void _triggerDeleteLocation(MapViewModel vm) async {
    bool? confirm = await MapDialogHelper.showCustomStyledDialog(
      context: context,
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
                  onCameraIdle: () => vm.onCameraIdle(context),
                  onCameraMove: vm.onCameraMove,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  polylines: vm.polylines,
                  markers: vm.markers,
                  clusterManagers: {
                    ClusterManager(
                      clusterManagerId: const ClusterManagerId(
                        'restaurant_cluster',
                      ),
                      onClusterTap: (Cluster cluster) {
                        vm.zoomToCluster(cluster.position);
                      },
                    ),
                  },
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

              _buildFloatingVerticalButton(context),

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

              if (vm.addingMode) ...[
                const Center(
                  child: IgnorePointer(
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.black87,
                    ),
                  ),
                ),
                Center(
                  child: IgnorePointer(
                    child: Transform.translate(
                      offset: const Offset(0, -5),
                      child: Icon(
                        Icons.add_location_alt_rounded,
                        color: vm.isStore
                            ? const Color(0xFF0D47A1)
                            : Colors.green,
                        size: 50,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

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
                                  currentWait: vm.getQueueForRestaurant(
                                    vm.selectedRestaurant!.id,
                                  ),
                                  restaurant: vm.selectedRestaurant!,
                                  distance: vm.routeDistance!,
                                  onClose: () {
                                    vm.clearRoute();
                                    setState(() => _panelHeight = _peekHeight);
                                  },
                                  onNavigation: () =>
                                      vm.getDirectionsToRestaurant(
                                        vm.selectedRestaurant!,
                                      ),
                                )
                              : RestaurantPanel(
                                  currentWait: vm.getQueueForRestaurant(
                                    vm.selectedRestaurant!.id,
                                  ),
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
                                      MapDialogHelper.openContactDetailsOrEditor(
                                        context: context,
                                        vm: vm,
                                        restaurant: vm.selectedRestaurant!,
                                      ),
                                  onDeleteLocation: () =>
                                      _triggerDeleteLocation(vm),
                                  onEditLocation: () {
                                    _closePanel(vm);
                                    vm.setAddingMode(true);
                                  },
                                  onShareTap: () =>
                                      MapDialogHelper.showShareDialog(
                                        context: context,
                                        restaurant: vm.selectedRestaurant!,
                                      ),
                                  onEditMenuTap: () =>
                                      MapDialogHelper.openMenuImageEditor(
                                        context: context,
                                        vm: vm,
                                        restaurant: vm.selectedRestaurant!,
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

  Widget _buildFloatingVerticalButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: GestureDetector(
          onTap: () => MapDialogHelper.showLineDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(Color(0xFF10B981)),
                const SizedBox(height: 12),
                _buildDot(Color(0xFFF97316)),
                const SizedBox(height: 12),
                _buildDot(Color(0xFFDC2626)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
