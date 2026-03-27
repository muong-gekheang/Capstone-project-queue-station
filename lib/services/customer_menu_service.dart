import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_size/menu_size_repository.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';

class CustomerMenuService {
  final MenuItemRepository _menuItemRepository;
  final MenuCategoryRepository _menuCategoryRepository;
  final AddOnRepository _addOnRepository;
  final MenuSizeRepository _menuSizeRepository;
  final SizingOptionRepository _sizingOptionRepository;

  CustomerMenuService({
    required MenuItemRepository menuItemRepository,
    required MenuCategoryRepository menuCategoryRepository,
    required AddOnRepository addOnRepository,
    required MenuSizeRepository menuSizeRepository,
    required SizingOptionRepository sizingOptionRepository,
  }) : _menuItemRepository = menuItemRepository,
       _menuCategoryRepository = menuCategoryRepository,
       _addOnRepository = addOnRepository,
       _menuSizeRepository = menuSizeRepository,
       _sizingOptionRepository = sizingOptionRepository;

  /// Fetch categories for a specific restaurant
  Future<List<MenuItemCategory>> getCategories(String restaurantId) async {
    try {
      final (categories, _) = await _menuCategoryRepository.getAll(50, null);
      // Filter for this restaurant if the repo doesn't do it automatically
      return categories.where((c) => c.restaurantId == restaurantId).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  /// Get paginated and enriched menu items
  Future<(List<dynamic>, DocumentSnapshot<Map<String, dynamic>>?)>
  getMenuItems(
    String restaurantId, {
    String? categoryId,
    String? searchQuery,
    int limit = 20,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  }) async {
    try {
      List<MenuItem> items;
      DocumentSnapshot<Map<String, dynamic>>? nextDoc;

      // 1. Fetch raw items based on filter type
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final (res, doc) = await _menuItemRepository.getSearchMenuItems(
          restaurantId,
          searchQuery,
          limit,
          lastDoc,
        );
        items = res;
        nextDoc = doc;
      } else if (categoryId != null && categoryId.isNotEmpty) {
        final (res, doc) = await _menuItemRepository.getMenuItemByCategoryId(
          restaurantId,
          categoryId,
          limit,
          lastDoc,
        );
        items = res;
        nextDoc = doc;
      } else {
        final (res, doc) = await _menuItemRepository.getAll(
          restaurantId,
          limit,
          lastDoc,
        );
        items = res;
        nextDoc = doc;
      }

      // 2. Enrich the items with full Sizes and Add-ons
      final enrichedItems = await Future.wait(
        items.map((item) => _enrichItem(item)),
      );

      return (enrichedItems, nextDoc);
    } catch (e) {
      debugPrint('Error in CustomerMenuService: $e');
      return ([], null);
    }
  }

  /// Internal helper to pull full objects for sizes and add-ons
  Future<MenuItem> _enrichItem(MenuItem item) async {
    try {
      // Fetch data in parallel for speed
      final results = await Future.wait([
        _fetchSizes(item.menuSizeOptionIds),
        _fetchAddOns(item.addOnIds),
      ]);

      final sizes = results[0] as List<MenuSize>;
      final addOns = results[1] as List;

      // Logic for price display: find the lowest price among sizes
      final minPrice = sizes.isNotEmpty
          ? sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b)
          : item.minPrice;

      return item.copyWith(
        sizes: sizes,
        addOns: addOns.cast(),
        minPrice: minPrice,
      );
    } catch (e) {
      debugPrint('Enrichment failed for ${item.name}: $e');
      return item;
    }
  }

  Future<List<MenuSize>> _fetchSizes(List<String> sizeIds) async {
    if (sizeIds.isEmpty) return [];

    final sizes = await Future.wait(
      sizeIds.map((id) => _menuSizeRepository.getMenuSizeById(id)),
    );

    final validSizes = sizes.whereType<MenuSize>().toList();

    // Attach SizeOption (Small, Medium, etc.) to the MenuSize
    for (var size in validSizes) {
      if (size.sizeOptionId.isNotEmpty) {
        size.sizeOption = await _sizingOptionRepository.getById(
          size.sizeOptionId,
        );
      }
    }

    return validSizes;
  }

  Future<List> _fetchAddOns(List<String> addOnIds) async {
    if (addOnIds.isEmpty) return [];
    final addOns = await Future.wait(
      addOnIds.map((id) => _addOnRepository.getAddOnById(id)),
    );
    return addOns.where((a) => a != null).toList();
  }
}