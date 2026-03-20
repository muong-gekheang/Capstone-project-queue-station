import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';

class EditAccountViewModel extends ChangeNotifier {

  final UserRepository<Customer> userRepository;
  final UserProvider userProvider;

  EditAccountViewModel({
    required this.userRepository,
    required this.userProvider,
  }) {
    _initialize();
  }

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

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
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      _selectedImage = File(image.path);
      notifyListeners();
    }
  }

  Future<bool> saveProfile() async {

    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (_user == null) return false;

    _isSaving = true;
    notifyListeners();

    try {

      final updatedUser = _user!.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
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