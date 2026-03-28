import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:queue_station_app/data/repositories/image/image_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';

class EditAccountViewModel extends ChangeNotifier {
  final UserRepository<Customer> userRepository;
  final UserProvider userProvider;
  final ImageRepository imageRepository;

  EditAccountViewModel({
    required this.userRepository,
    required this.userProvider,
    required this.imageRepository,
  }) {
    _initialize();
  }

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? get profileLink => _user?.profileLink;
  Uint8List? _pickedImageBytes;
  Uint8List? get pickedImageBytes => _pickedImageBytes;

  Customer? _user;

  void _initialize() {
    _user = userProvider.asCustomer;

    if (_user != null) {
      nameController.text = _user!.name;
      emailController.text = _user!.email;
      phoneController.text = _user!.phone;
    }
  }

  Future<void> pickAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) return;
    _pickedImageBytes = await pickedImage.readAsBytes();
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (_user == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      String? uploadedUrl;

      if (pickedImageBytes != null) {
        uploadedUrl = await imageRepository.uploadProfileImage(
          _pickedImageBytes!,
          _user!.id,
        );
      }

      final updatedUser = _user!.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        profileLink: uploadedUrl ?? _user!.profileLink,
      );

      await userRepository.update(updatedUser);

      /// update global state
      userProvider.updateUser(updatedUser);

      _user = updatedUser;

      return true;
    } catch (e) {
      debugPrint("Update user error: $e");
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
