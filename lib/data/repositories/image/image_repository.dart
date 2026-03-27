import 'dart:typed_data';

abstract class ImageRepository {
  // upload logo is for upload the image into the firebase storage
  Future<String> uploadLogo(Uint8List bytes, String fileName);
  // saveLogoUrl is for saving the url link in the firestore.
  Future<void> saveLogoUrl(String logoUrl, String restaurantId);
  Future<void> deleteLogo(String imageUrl);
  Future<String> uploadProfileImage(Uint8List bytes, String userId);
  Future<void> saveProfileImageUrl(String imageUrl, String userId);
}
