import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:queue_station_app/data/repositories/image/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final FirebaseFirestore fireStore;
  final FirebaseStorage firebaseStorage;
  ImageRepositoryImpl({
    FirebaseFirestore? fireStore,
    FirebaseStorage? firebaseStorage,
  }) : fireStore = fireStore ?? FirebaseFirestore.instance,
       firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  // upload logo is for upload the image into the firebase storage
  @override
  Future<String> uploadLogo(Uint8List bytes, String fileName) async {
    final ref = firebaseStorage.ref('restaurant_logos/$fileName');
    await ref.putData(bytes); // Upload image bytes
    final url = await ref.getDownloadURL(); // Get HTTPS link of uploaded image
    return url;
  }

  // saveLogoUrl is for saving the url link in the firestore.
  @override
  Future<void> saveLogoUrl(String logoUrl, String restaurantId) async {
    final docRef = fireStore.collection('restaurants').doc(restaurantId);
    await docRef.update({'logoLink': logoUrl});
  }
  
  @override
  Future<void> deleteLogo(String imageUrl) async {
    final ref = firebaseStorage.refFromURL(imageUrl);
    await ref.delete();
  }







}
