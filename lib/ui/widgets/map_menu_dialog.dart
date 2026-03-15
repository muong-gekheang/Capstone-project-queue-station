import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color appBlue = Color(0xFF154394);
const Color appOrange = Color(0xFFF05A28);

class AddMenuImageDialog extends StatefulWidget {
  final List<String> initialImageLinks;

  const AddMenuImageDialog({super.key, this.initialImageLinks = const []});

  @override
  State<AddMenuImageDialog> createState() => _AddMenuImageDialogState();
}

class _AddMenuImageDialogState extends State<AddMenuImageDialog> {
  final List<String> _selectedMenuImageLinks = [];
  late final TextEditingController _imageLinkController;

  @override
  void initState() {
    super.initState();
    _selectedMenuImageLinks.addAll(widget.initialImageLinks);
    _imageLinkController = TextEditingController();
  }

  Future<void> _pickMenuImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(
        () => _selectedMenuImageLinks.addAll(images.map((img) => img.path)),
      );
    }
  }

  void _addImageLink() {
    final String link = _imageLinkController.text.trim();
    if (link.isEmpty) return;
    setState(() {
      _selectedMenuImageLinks.add(link);
      _imageLinkController.clear();
    });
  }

  void _removeMenuImage(int index) =>
      setState(() => _selectedMenuImageLinks.removeAt(index));

  @override
  void dispose() {
    _imageLinkController.dispose();
    super.dispose();
  }

  void _saveMenu() {
    Navigator.pop(context, List<String>.from(_selectedMenuImageLinks));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: appBlue, width: 2.5),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu Images',
                    style: TextStyle(
                      color: appOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: appBlue,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: appOrange,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 3, width: double.infinity, color: appBlue),
              const SizedBox(height: 16),

              // Content
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _imageLinkController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        labelStyle: TextStyle(color: appBlue),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addImageLink,
                    icon: const Icon(Icons.add_circle, color: appOrange),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ..._selectedMenuImageLinks.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String link = entry.value;
                    return Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: appBlue),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildThumb(link),
                          ),
                        ),
                        Positioned(
                          top: -1.5,
                          right: -1.5,
                          child: IconButton(
                            icon: const Icon(
                              Icons.do_not_disturb_on,
                              color: Colors.red,
                            ),
                            onPressed: () => _removeMenuImage(index),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: _pickMenuImages,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: appBlue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: appBlue),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, color: appBlue),
                          SizedBox(height: 4),
                          Text(
                            'Import',
                            style: TextStyle(color: appBlue, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _saveMenu,
                  child: const Text(
                    'SAVE MENU',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumb(String link) {
    if (link.startsWith('http')) {
      return Image.network(
        link,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image),
        ),
      );
    }
    return Image.file(
      File(link),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image),
      ),
    );
  }
}
