import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:leafguard/screens/result_screen.dart';

class ImageService {
  final _picker = ImagePicker();

  Future<Permission> _getGalleryPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    return sdkInt >= 33 ? Permission.photos : Permission.storage;
  }

  Future<File?> pickImage(BuildContext context, ImageSource source) async {
    final permission = source == ImageSource.camera
        ? Permission.camera
        : (Platform.isAndroid
            ? await _getGalleryPermission()
            : Permission.photos);

    final status = await permission.request();

    if (!context.mounted) return null;

    if (status.isDenied || status.isPermanentlyDenied) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Permission denied'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: openAppSettings,
          ),
        ),
      );
      return null;
    }

    final XFile? image = await _picker.pickImage(source: source);
    if (!context.mounted) return null;

    if (image != null) {
      final File photo = File(image.path);

      // Navigate immediately; model will run in ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(image: photo),
        ),
      );

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
}