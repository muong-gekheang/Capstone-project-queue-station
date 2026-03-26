import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/restaurant/restaurant_social.dart';
import 'package:queue_station_app/ui/screens/map/map_view_model/map_view_model.dart';
import 'package:queue_station_app/ui/screens/map/widgets/map_contact_dialogs.dart';
import 'package:queue_station_app/ui/screens/map/widgets/map_menu_dialog.dart';
import 'package:share_plus/share_plus.dart';

class MapDialogHelper {
  /// set and delete location dialog
  static Future<bool?> showCustomStyledDialog({
    required BuildContext context,
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

  // open contact
  // --- DIALOG LOGIC ---
  static Future<void> openContactEditor({
    required BuildContext context,
    required MapViewModel vm,
    required Restaurant restaurant,
    required List<SocialAccount> realAccounts,
  }) async {
    final ContactFormResult? result = await showDialog<ContactFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddContactDialog(initialAccounts: realAccounts),
    );
    if (result != null) {
      vm.updateContactInfo(restaurant.id, result.socialAccounts);
    }
  }

  // Contact details or editor
  static void openContactDetailsOrEditor({
    required BuildContext context,
    required MapViewModel vm,
    required Restaurant restaurant,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF6835)),
      ),
    );

    List<SocialAccount> realAccounts = await vm.getRealSocialAccounts(
      restaurant.contactDetailIds!,
    );

    if (!context.mounted) return;
    Navigator.pop(context);

    if (realAccounts.isEmpty && vm.isStore && vm.myStore?.id == restaurant.id) {
      openContactEditor(
        context: context,
        vm: vm,
        restaurant: restaurant,
        realAccounts: realAccounts,
      );
      return;
    }

    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ContactDetailsDialog(
        socialAccounts: realAccounts,
        onEdit: () {
          Navigator.pop(dialogContext);
          openContactEditor(
            context: context,
            vm: vm,
            restaurant: restaurant,
            realAccounts: realAccounts,
          );
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

  static Future<void> openMenuImageEditor({
    required BuildContext context,
    required MapViewModel vm,
    required Restaurant restaurant,
  }) async {
    final List<String>? updatedLinks = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddMenuImageDialog(
        initialImageLinks: List<String>.from(restaurant.menuImageLinks),
      ),
    );
    if (updatedLinks != null) vm.updateMenuImages(restaurant.id, updatedLinks);
  }

  static void showShareDialog({
    required BuildContext context,
    required Restaurant restaurant,
  }) {
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
                              if (context.mounted) {
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

  /// Shows a simple loading spinner
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF6835)),
      ),
    );
  }

  static void showLineDialog(BuildContext context) {
    final List<Map<String, dynamic>> lineOptions = [
      {'color': Color(0xFF10B981), 'label': 'Short line'},
      {'color': Color(0xFFF97316), 'label': 'Medium line'},
      {'color': Color(0xFFDC2626), 'label': 'Long line'},
    ];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: lineOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: option['color'], radius: 20),
                    const SizedBox(width: 15),
                    Text(
                      option['label'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
