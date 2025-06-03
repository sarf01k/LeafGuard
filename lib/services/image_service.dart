import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final _picker = ImagePicker();

  Future<File?> pickImage(BuildContext context, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final File photo = File(image.path);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Selected Image'),
            content: Image.file(photo),
          ),
        );
      }

      return photo;
    }

    return null;
  }

  void openImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              pickImage(context, ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              pickImage(context, ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  // void pickImage(ImageSource source) async {
  //   final photo = await _imageService.pickImage(source);
  //   if (photo != null) {
  //     print("Picked image path: ${photo.path}");
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: const Text('Selected Image'),
  //         content: Image.file(photo),
  //       ),
  //     );
  //   } else {
  //     print('Image picking cancelled');
  //   }
  // }
}