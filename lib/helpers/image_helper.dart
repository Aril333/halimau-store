import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_platform/universal_platform.dart';

class PickedImage {
  final Uint8List bytes;
  final String name;

  PickedImage({required this.bytes, required this.name});
}

class ImageHelper {
  static Future<PickedImage?> pickImage() async {
    if (kIsWeb || UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS) {
      // Gunakan FilePicker untuk Web/Desktop
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        return PickedImage(
          bytes: result.files.single.bytes!,
          name: result.files.single.name,
        );
      }
    } else {
      // Gunakan ImagePicker untuk Android/iOS
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        return PickedImage(
          bytes: await picked.readAsBytes(),
          name: picked.name,
        );
      }
    }

    return null;
  }
}
