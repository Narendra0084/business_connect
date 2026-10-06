import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  ImagePickerUtils._();

  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickFromCamera({int imageQuality = 85, double maxWidth = 1600}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
      );

      return image?.path;
    } catch (e) {
      return null;
    }
  }
}
