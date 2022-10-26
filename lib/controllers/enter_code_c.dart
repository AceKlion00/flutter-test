import 'package:extra_staff/models/quick_add_tem_add_m.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class EnterCodeController extends GetxController {
  String otp = '    ';
  int selectedIndex = 0;
  final double textFiledWidth = 60;
  QuickAddTempAdd? data;
  final text = {
    'text': 'codeSent'.tr,
    'highlight': 'hCodeSent'.tr,
  };

  bool addOtp(int key, String str) {
    final strn = str == '' ? ' ' : str;
    otp = replaceCharAt(otp, key, strn);
    final value = otp.replaceAll(' ', '');
    return value.isNotEmpty && value.length == 4;
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  Future<BaseApiResponse> getQuickTempVerification() async {
    final response = await Services.shared
        .getQuickTempVerification(otp, data?.uniqueid ?? '');
    return response;
  }

  Future<String> resendQuickTempVerification() async {
    final response = await Services.shared
        .resendQuickTempVerification(otp, data?.uniqueid ?? '');
    if (response.result is Map) {
      data?.code = '${response.result['code_new']}';
      data?.uniqueid = response.result['uniqueid'];
      otp = '    ';
    }
    return response.errorMessage;
  }
}
