import 'dart:math';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/upload_documents_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:image_picker/image_picker.dart';

class ListToUploadController extends GetxController {
  XFile? image;
  DateTime? passportExpDate;
  bool isCV = false;
  bool isCVUploaded = false;
  bool isForklift = false;
  KeyValue type = KeyValue('license', 'drivinglicence'.tr);
  int selectedIndex = 0;
  bool isSingleImage() =>
      isCV ||
      isForklift ||
      (type.value.toLowerCase() != 'drivinglicence'.tr.toLowerCase() &&
          type.value.toLowerCase() != 'visaBrp'.tr.toLowerCase());
  bool? profilePicture;
  bool notHaveNi = false;
  bool isBack = false;

  String reasonForNotHaveNi = '';

  String get videoToPlay {
    String name = 'How2GeneralDocs';
    bool hasValue(String key) =>
        type.value.toLowerCase().contains(key.toLowerCase());
    if (hasValue('passport')) {
      name = 'How2Passport';
    } else if (hasValue('drivinglicence'.tr) || isForklift) {
      name = 'How2DrivingLicence';
    } else if (hasValue('visa') || hasValue('ni') || hasValue('payslip')) {
      name = 'How2Cards';
    }
    return 'lib/images/$name.mp4';
  }

  bool get showExpiryDate {
    if (data.isNotEmpty) {
      return isPassport(data[0].selected.value) ||
          data[0].selected.value == 'visaBrp'.tr ||
          data[0].selected.value == 'Current Immigration Status Document';
    } else {
      return false;
    }
  }

  bool get showAnalyzer {
    return (selectedIndex == 0 && data.isEmpty
        ? false
        : isPassport(data[0].selected.value));
  }

  List<Documents> data = [];

  final awsTypes = [
    KeyValue('passport', 'Passport'),
    KeyValue('license', 'Driving Licence'),
    KeyValue('statement', 'Bank Statement'),
    KeyValue('insurance', 'NI Card'),
    KeyValue('residentPermit', 'VISA / BRP Card'),
    KeyValue('councilTaxBill', 'Council Tax Bill'),
    KeyValue('birthCertificate', 'Birth Certificate'),
    KeyValue('hmrcLetter', 'HMRC Letter'),
    KeyValue('homeOfficeDoc', 'Home Office Letter'),
    KeyValue('tvLicense', 'TV Licence'),
    KeyValue('immigration', 'VISA / BRP Card'),
    KeyValue('p45', 'P45'),
    KeyValue('p60', 'P60'),
    KeyValue('payslip', 'Payslip'),
    KeyValue('marriageCertificate', 'Marriage Certificate'),
    KeyValue('jobCentreLetter', 'Job Centre Letter'),
  ];

  bool isPassport(String str) => str.toLowerCase().contains('passport');

  Future getUploadDocDropdownInfo() async {
    final apiData = await Services.shared.getUploadDocDropdownInfo();
    if (apiData.result is Map<String, dynamic>) {
      final allData = apiData.result as Map<String, dynamic>;
      final keys = allData.keys.toList();
      for (int i = 0; i < allData.length; i++) {
        final key = keys[i];
        data.add(Documents.fromJson(key, allData[key]));
      }
      if (data.isNotEmpty) {
        type = data.first.selected;
      }
    }
    if (apiData.errorMessage.isNotEmpty) {
      abShowMessage(apiData.errorMessage);
    }
  }

  Future getTempPhotoInfo() async {
    final apiData = await Services.shared.getTempPhotoInfo();
    if (apiData.result is Map) {
      profilePicture = ab(apiData.result['photo'], fallback: '').isNotEmpty;
    }
    if (apiData.errorMessage.isNotEmpty) {
      abShowMessage(apiData.errorMessage);
    }
  }

  Future<String> uploadImages() async {
    if (image == null) {
      return 'selectImage'.tr;
    }
    var message = '';
    final str = generateRandomString(32) + '.' + image!.path.split('.').last;
    String idToPass = '';
    if (isCV || isForklift) {
      idToPass = 'other';
    } else {
      idToPass = data[selectedIndex].selected.value;
      for (var type in awsTypes) {
        if (type.value == idToPass) {
          idToPass = type.id;
          break;
        }
      }
      if (isPassport(idToPass)) {
        idToPass = 'passport';
      }
    }
    if (idToPass == awsTypes[1].id && isBack) {
      idToPass = 'license_back';
    }
    final getUrl = await Services.shared.getUploadUrl(idToPass, str);
    message = getUrl.message;
    final uploadImage =
        await Services.shared.putImage(getUrl.data['url'], image!);
    message = uploadImage;
    final type = isCV
        ? 'CV'
        : isForklift
            ? 'Forklift'
            : data[selectedIndex].id;
    final docType = isCV
        ? 'CV'
        : isForklift
            ? 'Forklift'
            : data[selectedIndex].selected.value;
    await Future.delayed(Duration(seconds: 6), () {});
    final tempCompDoc =
        await Services.shared.tempCompDoc(type, docType, str, isBack);
    message = tempCompDoc.errorMessage;
    return message;
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future getTempCompDocInfo() async {
    final result = await Services.shared.getTempCompDocInfo();
    if (result.result is Map) {
      Map<String, dynamic> expDate = {};
      (result.result as Map).forEach((key, value) async {
        if (key == 'is_have_ni') {
          notHaveNi = value['id'] == '1';
          await localStorage?.setBool('isNiUploaded', !notHaveNi);
          return;
        } else if (key == 'is_have_ni_reason') {
          reasonForNotHaveNi = value;
          return;
        }
        final index = data.indexWhere((element) => element.id == key);
        final v = KeyValue.fromJson(value);
        if (v.value.isNotEmpty) {
          final selected = data[index].data.firstWhere((e) => e.id == v.id);
          data[index].selected = selected;
          data[index].status = true;
        }
        if (key == 'exp_date') {
          expDate = value;
        }
      });

      expDate.forEach((key, value) {
        final isPassport = data[0].selected.value == 'passport'.tr;
        if (isPassport) {
          passportExpDate = stringToDate(expDate['passport_expiry'], true);
        } else {
          passportExpDate = stringToDate(expDate['immi_expiry'], true);
        }
      });
    }
    if (notHaveNi && data.length > 1) {
      data[1].selected = data[1].data.first;
      data[1].status = null;
    }
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    }
  }

  Future updateTempComplianceDocExpiry() async {
    final date = dateToString(passportExpDate, true);
    final isPassport = data[0].selected.value == 'passport'.tr;
    final result = await Services.shared.updateTempComplianceDocExpiry(
      isPassport ? date : null,
      !isPassport ? date : null,
      notHaveNi,
      reasonForNotHaveNi,
    );
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    } else {
      await localStorage?.setBool('isNiUploaded', !notHaveNi);
    }
  }

  Future getTempCVInfo() async {
    final result = await Services.shared.getTempCVInfo();
    if (result.result is Map) {
      isCVUploaded = result.result['is_exist'] == 1;
    }
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    }
  }

  Future getTempDeskInfo() async {
    final result = await Services.shared.getTempDeskInfo();
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    } else {
      if (result.result['isDriver'] is bool) {
        await localStorage?.setBool('isDriver', result.result['isDriver']);
      }
    }
  }

  Future tempPassportExpiryInfo() async {
    final date = dateToString(passportExpDate, true) ?? '';
    final result = await Services.shared.tempPassportExpiryInfo(date);
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    }
  }
}
