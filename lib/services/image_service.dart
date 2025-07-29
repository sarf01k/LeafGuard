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
    final mounted = context.mounted;

    final permission = source == ImageSource.camera
        ? Permission.camera
        : (Platform.isAndroid
            ? await _getGalleryPermission()
            : Permission.photos);

    final status = await permission.request();

    if (!mounted || !context.mounted) return null;

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

  void openImagePickerOptions(BuildContext parentContext, ImageService imageService) {
  showModalBottomSheet(
    context: parentContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (BuildContext sheetContext) {
      return Wrap(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt),
                SizedBox(width: 8),
                const Text(
                  'Take Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  )
                ),
              ],
            ),
            onTap: () async {
              Navigator.pop(sheetContext); // Close bottom sheet
              await Future.delayed(Duration(milliseconds: 200)); // Let sheet fully close
              if (parentContext.mounted) {
                await imageService.pickImage(parentContext, ImageSource.camera);
              } else {
              }
            },
          ),
          Divider(),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo_library),
                SizedBox(width: 8),
                const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  )
                ),
              ],
            ),
            onTap: () async {
              Navigator.pop(sheetContext);
              await Future.delayed(Duration(milliseconds: 200));
              if (parentContext.mounted) {
                await imageService.pickImage(parentContext, ImageSource.gallery);
              } else {
              }
            },
          ),
        ],
      );
    },
  );
}

}