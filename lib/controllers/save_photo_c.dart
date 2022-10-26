import 'dart:math';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:image_picker/image_picker.dart';

class SavePhotoController extends GetxController {
  bool? safetyBoots;
  XFile? image;

  Future<String> profileUploadUrl() async {
    if (image == null) {
      return 'selectImage'.tr;
    }
    var message = '';
    final str = generateRandomString(32) + '.' + image!.path.split('.').last;
    final getUrl = await Services.shared.profileUploadUrl(str);
    message = getUrl.message;
    final uploadImage =
        await Services.shared.putImage(getUrl.data['url'], image!);
    message = uploadImage;
    final photoInfo = await Services.shared.updateTempPhotoInfo(str);
    message = photoInfo.errorMessage;
    return message;
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
