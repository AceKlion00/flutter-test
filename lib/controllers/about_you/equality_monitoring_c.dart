import 'package:extra_staff/models/drop_donws_m.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class EqualityMonitoringController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserData data = UserData.fromJson({});
  DateTime selectedAge = getNow;
  KeyValue selectedNationalIdentity = KeyValue.fromJson({});
  KeyValue selectedEthnic = KeyValue.fromJson({});
  KeyValue selectedGender = KeyValue.fromJson({});
  KeyValue selectedReligion = KeyValue.fromJson({});
  bool? marriedOrCivil;
  bool? disability;

  DropDowns dropDowns = DropDowns.fromJson({});
  Future<String> getTempEqualityInfo() async {
    final response = await Services.shared.getTempEqualityInfo();
    if (response.errorCode == 0) {
      final data2 = UserData.fromJson(response.result);
      data.nationalIdentity = data2.nationalIdentity;
      data.ethnic = data2.ethnic;
      data.tempGender = data2.tempGender;
      data.religion = data2.religion;
      data.sexOri = data2.sexOri;
      data.tempDob = data2.tempDob;
      data.married = data2.married;
      data.tempDisability = data2.tempDisability;
      data.tempDisabilityDesc = data2.tempDisabilityDesc;

      marriedOrCivil = data.married == '' ? null : data.married == 'true';
      disability =
          data.tempDisability == '' ? null : data.tempDisability == 'true';
    }
    return response.errorMessage;
  }

  Future<String> getTempEqualityOptionInfo() async {
    final response = await Services.shared.getEqualityOptionInfo();
    dropDowns = DropDowns.fromJson(response.result);
    return response.errorMessage;
  }

  Future<String> updateTempEqualityInfo() async {
    final response = await Services.shared.updateTempEqualityInfo(data);
    return response.errorMessage;
  }

  Future getAndSetData() async {
    await getTempEqualityInfo();
    await getTempEqualityOptionInfo();
    selectedNationalIdentity = dropDowns.nationalIdentity.first;
    selectedEthnic = dropDowns.ethnic.first;
    selectedGender = dropDowns.tempGender.first;
    selectedReligion = dropDowns.religion.first;

    selectedAge = stringToDate(data.tempDob);

    if (data.nationalIdentity.isNotEmpty) {
      final index = dropDowns.nationalIdentity
          .indexWhere((element) => element.id == data.nationalIdentity);
      selectedNationalIdentity = dropDowns.nationalIdentity[index];
    } else {
      selectedNationalIdentity = dropDowns.nationalIdentity.first;
    }

    if (data.ethnic.isNotEmpty) {
      final index =
          dropDowns.ethnic.indexWhere((element) => element.id == data.ethnic);
      selectedEthnic = dropDowns.ethnic[index];
    } else {
      selectedEthnic = dropDowns.ethnic.first;
    }

    if (data.tempGender.isNotEmpty) {
      final index = dropDowns.tempGender
          .indexWhere((element) => element.id == data.tempGender);
      selectedGender = dropDowns.tempGender[index];
    } else {
      selectedGender = dropDowns.tempGender.first;
    }

    if (data.religion.isNotEmpty) {
      final index = dropDowns.religion
          .indexWhere((element) => element.id == data.religion);
      selectedReligion = dropDowns.religion[index];
    } else {
      selectedReligion = dropDowns.religion.first;
    }
  }

  String validate() {
    if (marriedOrCivil == null) {
      return 'civilPartnerhip'.tr;
    } else if (disability == null) {
      return 'disability'.tr;
    } else if (data.tempDob.isEmpty) {
      return 'validBirthdate'.tr;
    } else if (!formKey.currentState!.validate()) {
      return 'error'.tr;
    }
    return '';
  }

  setDate(DateTime date) => data.tempDob = dateToString(date);

  DateTime stringToDate(String dateTime) {
    try {
      return serverDateFormat.parse(dateTime);
    } catch (e) {
      print('Error wrong date');
      return selectedAge;
    }
  }

  String dateToString(DateTime dateTime) {
    try {
      return serverDateFormat.format(dateTime);
    } catch (e) {
      print('Error wrong date');
      return serverDateFormat.format(getNow);
    }
  }
}
