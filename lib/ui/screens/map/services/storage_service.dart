import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadMenuImage(
    String restaurantId,
    String localPath,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not authenticated. Cannot upload image.");
      }
      final File file = File(localPath);

      if (!await file.exists()) {
        throw Exception("The file at $localPath does not exist!");
      }

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref = FirebaseStorage.instance.ref().child(
        'restaurant_map_menus/$restaurantId/$fileName.jpg',
      );

      // If the emulator is offline, this stops it from hanging forever
      final TaskSnapshot snapshot = await ref
          .putFile(file)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                throw Exception("Upload timed out. Check emulator internet!"),
          );

      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Firebase Storage Error Code: ${e.code}");
      print("Firebase Storage Error Message: ${e.message}");
      throw Exception("Firebase Error: ${e.message}");
    } catch (e) {
      print("General Error uploading image: $e");
      rethrow;
      // throw Exception("Failed to upload image");
    }
  }

  // --- DELETE ---
  static Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      print("Successfully deleted image from storage.");
    } catch (e) {
      print("Error deleting image from storage: $e");
    }
  }
}
