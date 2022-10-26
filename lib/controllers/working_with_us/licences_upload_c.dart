import 'dart:convert';
import 'dart:math';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum LicenceType { licence, tacho, qualification }

class LicencesUploadController extends GetxController {
  DateTime? expDate;
  DateTime? passDate;

  XFile? front;
  XFile? back;

  KeyValue selectedCountry = KeyValue('', '');
  List<KeyValue> countryOptions = [];

  bool isOnly35T = false;
  LicenceType type = LicenceType.licence;

  bool allFinished = false;

  String get title {
    switch (type) {
      case LicenceType.licence:
        return 'Driving licence';
      case LicenceType.tacho:
        return 'Tacho card';
      case LicenceType.qualification:
        return 'Driver qualification card';
      default:
        return '';
    }
  }

  String drivingIssueDate = '';
  String drivingDateExpiry = '';
  String drivingLicenseDocID = '';
  String drivingLicenseBackDocID = '';

  String tachoCountry = '';
  String tachoDateExpiry = '';
  String tacocardDocID = '';
  String tacocardBackDocID = '';

  String digicardCountry = '';
  String digicardDateExpiry = '';
  String digicardDocID = '';
  String digicardBackDocID = '';

  bool get isCompleted {
    if (type == LicenceType.licence) {
      return drivingIssueDate.isNotEmpty &&
          drivingDateExpiry.isNotEmpty &&
          drivingLicenseDocID.isNotEmpty &&
          drivingLicenseBackDocID.isNotEmpty;
    } else if (type == LicenceType.tacho) {
      return tachoCountry.isNotEmpty &&
          tachoDateExpiry.isNotEmpty &&
          tacocardDocID.isNotEmpty &&
          tacocardBackDocID.isNotEmpty;
    } else {
      return digicardCountry.isNotEmpty &&
          digicardDateExpiry.isNotEmpty &&
          digicardDocID.isNotEmpty &&
          digicardBackDocID.isNotEmpty;
    }
  }

  String awsType(bool isFront) {
    switch (type) {
      case LicenceType.licence:
        return isFront ? 'license' : 'license_back';
      case LicenceType.tacho:
        return isFront ? 'tacho_front' : 'tacho_back';
      case LicenceType.qualification:
        return isFront ? 'digicard_front' : 'digicard_back';
    }
  }

  bool isUploaded(bool isFront) {
    bool isUploaded = isFront ? front != null : back != null;
    if (type == LicenceType.licence) {
      isUploaded = isFront
          ? drivingLicenseDocID.isNotEmpty
          : drivingLicenseBackDocID.isNotEmpty;
    } else if (type == LicenceType.tacho) {
      isUploaded =
          isFront ? tacocardDocID.isNotEmpty : tacocardBackDocID.isNotEmpty;
    } else if (type == LicenceType.qualification) {
      isUploaded =
          isFront ? digicardDocID.isNotEmpty : digicardBackDocID.isNotEmpty;
    }
    return isUploaded;
  }

  reset() {
    if (countryOptions.isNotEmpty) {
      selectedCountry = countryOptions.first;
    }
    front = null;
    back = null;
    expDate = null;
    passDate = null;
  }

  getDataFromStorage() {
    final storedData = localStorage?.getString('RolesView') ?? '';
    final map = json.decode(storedData);
    isOnly35T = map['isOnly35T'];

    final storedType = localStorage?.getString('LicenceType') ??
        LicenceType.licence.toString();
    type = LicenceType.values.firstWhere((e) => e.toString() == storedType);
  }

  Future<String> getCountryDropdownInfo() async {
    final response = await Services.shared.getCountryDropdownInfo();
    if (response.result is Map && response.result['country_id'] is List) {
      countryOptions.add(KeyValue('', 'Please select country'));
      for (var item in response.result['country_id']) {
        countryOptions.add(KeyValue.fromJson(item));
      }
      if (countryOptions.isNotEmpty) {
        selectedCountry = countryOptions.first;
      }
    }
    return response.errorMessage;
  }

  Future getTempLicenseInfo() async {
    if (isDriver) {
      final response = await Services.shared.getTempLicenseInfo();
      if (response.errorMessage.isNotEmpty) {
        abShowMessage(response.errorMessage);
      } else {
        drivingIssueDate = response.result['driving_issue_date'] ?? '';
        drivingDateExpiry = response.result['driving_date_expiry'] ?? '';
        drivingLicenseDocID = response.result['driving_license_doc_id'] ?? '';
        drivingLicenseBackDocID =
            response.result['driving_license_back_doc_id'] ?? '';

        tachoCountry = response.result['tacho_country'] ?? '';
        tachoDateExpiry = response.result['tacho_date_expiry'] ?? '';
        tacocardDocID = response.result['tacocard_doc_id'] ?? '';
        tacocardBackDocID = response.result['tacocard_back_doc_id'] ?? '';

        digicardCountry = response.result['digicard_country'] ?? '';
        digicardDateExpiry = response.result['digicard_date_expiry'] ?? '';
        digicardDocID = response.result['digicard_doc_id'] ?? '';
        digicardBackDocID = response.result['digicard_back_doc_id'] ?? '';

        switch (type) {
          case LicenceType.licence:
            passDate = stringToDate(drivingIssueDate, true);
            expDate = stringToDate(drivingDateExpiry, true);
            return;
          case LicenceType.tacho:
            expDate = stringToDate(tachoDateExpiry, true);
            selectedCountry = countryOptions.firstWhere(
                (e) => e.id == tachoCountry,
                orElse: () => countryOptions.first);
            return;
          case LicenceType.qualification:
            expDate = stringToDate(digicardDateExpiry, true);
            selectedCountry = countryOptions.firstWhere(
                (e) => e.id == digicardCountry,
                orElse: () => countryOptions.first);
            return;
          default:
            return;
        }
      }
    }
  }

  changeType() async {
    if (isOnly35T) {
      allFinished = true;
    } else {
      reset();
      if (type == LicenceType.licence) {
        type = LicenceType.tacho;
        expDate = stringToDate(tachoDateExpiry, true);
        selectedCountry =
            countryOptions.firstWhere((e) => e.id == tachoCountry);
      } else if (type == LicenceType.tacho) {
        type = LicenceType.qualification;
        expDate = stringToDate(digicardDateExpiry, true);
        selectedCountry =
            countryOptions.firstWhere((e) => e.id == digicardCountry);
      } else {
        allFinished = true;
      }
      await localStorage?.setString('LicenceType', type.toString());
    }
  }

  bool changeTypeOnBack() {
    reset();
    bool isChanged = true;
    if (Get.previousRoute.substring(1) == 'RegistrationView' ||
        type == LicenceType.licence) {
      isChanged = false;
      Get.back();
    } else if (type == LicenceType.qualification) {
      type = LicenceType.tacho;
    } else {
      type = LicenceType.licence;
    }
    return isChanged;
  }

  Future<String> uploadImages(int index) async {
    if ((index == 0 && front == null) || (index == 1 && back == null)) {
      return 'selectImage'.tr;
    }

    final image = index == 0 ? front! : back!;

    var message = '';
    final awsUrlType = awsType(index == 0);
    final str = generateRandomString(32) + '.' + image.path.split('.').last;
    final getUrl = await Services.shared.getUploadUrl(awsUrlType, str);
    message = getUrl.message;
    final uploadImage =
        await Services.shared.putImage(getUrl.data['url'], image);
    message = uploadImage;
    String passType = '';
    switch (type) {
      case LicenceType.licence:
        passType = index == 0
            ? 'driving_license_doc_id'
            : 'driving_license_back_doc_id';
        break;
      case LicenceType.tacho:
        passType = index == 0 ? 'tacocard_doc_id' : 'tacocard_back_doc_id';
        break;
      case LicenceType.qualification:
        passType = index == 0 ? 'digicard_doc_id' : 'digicard_back_doc_id';
        break;
      default:
        passType = '';
    }
    String? drivingDExp =
        type == LicenceType.licence ? dateToString(expDate, true) : null;
    String? drivingDIssue =
        type == LicenceType.licence ? dateToString(passDate, true) : null;
    String? tachoDExp =
        type == LicenceType.tacho ? dateToString(expDate, true) : null;
    String? tachoCt = type == LicenceType.tacho ? selectedCountry.id : null;
    String? digiDExp =
        type == LicenceType.qualification ? dateToString(expDate, true) : null;
    String? digiCt =
        type == LicenceType.qualification ? selectedCountry.id : null;
    final tempCompDoc = await Services.shared.tempCompDoc(
      passType,
      passType,
      str,
      index != 0,
      drivingDExp: drivingDExp,
      drivingDIssue: drivingDIssue,
      tachoDExp: tachoDExp,
      tachoCt: tachoCt,
      digiDExp: digiDExp,
      digiCt: digiCt,
    );
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

  Future<String> updateTempLicenseAdditionalInfo() async {
    String typeToSend = '';
    String docId = '';
    if (type == LicenceType.licence) {
      typeToSend = 'driving_license_doc_id';
      docId = drivingLicenseDocID;
    } else if (type == LicenceType.tacho) {
      typeToSend = 'tacocard_doc_id';
      docId = tacocardDocID;
    } else {
      typeToSend = 'digicard_doc_id';
      docId = digicardDocID;
    }
    String? drivingDExp =
        type == LicenceType.licence ? dateToString(expDate, true) : null;
    String? drivingDIssue =
        type == LicenceType.licence ? dateToString(passDate, true) : null;
    String? tachoDExp =
        type == LicenceType.tacho ? dateToString(expDate, true) : null;
    String? tachoCt = type == LicenceType.tacho ? selectedCountry.id : null;
    String? digiDExp =
        type == LicenceType.qualification ? dateToString(expDate, true) : null;
    String? digiCt =
        type == LicenceType.qualification ? selectedCountry.id : null;
    final result = await Services.shared.updateTempLicenseAdditionalInfo(
      typeToSend,
      docId,
      drivingDExp ?? '',
      drivingDIssue ?? '',
      tachoDExp ?? '',
      tachoCt ?? '',
      digiDExp ?? '',
      digiCt ?? '',
    );
    return result.errorMessage;
  }

  String validate() {
    if (type == LicenceType.licence) {
      if (expDate == null || passDate == null) {
        return 'Please enter all data';
      }
    } else {
      if (expDate == null || selectedCountry.id.isEmpty) {
        return 'Please enter all data';
      }
    }
    return '';
  }
}
