import 'package:extra_staff/models/drop_donws_m.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AvailabilityController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? areYouInterested;

  DateTime? selectedDob;
  bool? hasCriminalConvictions;

  final contactRelationship = [
    KeyValue('', 'Please select option'),
    KeyValue('Family Member', 'Family Member'),
    KeyValue('Friend', 'Friend'),
    KeyValue('Colleague', 'Colleague'),
  ];

  KeyValue get selectedRelationship {
    final ind = contactRelationship.indexWhere(
        (element) => element.id == data.emergencyContactRelationship);
    if (ind >= 0) {
      return contactRelationship[ind];
    } else {
      data.emergencyContactRelationship = contactRelationship.first.id;
      return contactRelationship.first;
    }
  }

  KeyValue selectedES = KeyValue.fromJson({});
  List<KeyValue> esValues = [
    KeyValue('', 'Please select option'),
    KeyValue('T.O.E.', 'PAYE'),
    KeyValue('Umbrella', 'Paid through Umbrella'),
  ];
  KeyValue selectedItem = KeyValue.fromJson({});
  KeyValue selectedEU = KeyValue.fromJson({});
  UserData data = UserData.fromJson({});
  DropDowns dropDowns = DropDowns.fromJson({});

  String formatDateStr() => selectedDob == null ? '' : formatDate(selectedDob!);

  setData() async {
    final dob = stringToDate(data.dob);
    if (data.contract.isEmpty) {
      selectedES = esValues.first;
    } else {
      selectedES =
          esValues.firstWhere((element) => element.id == data.contract);
    }
    if (dob != null && dob.isAfter(minDate) && dob.isBefore(maxDate)) {
      selectedDob = stringToDate(data.dob);
    } else {
      data.dob = '';
    }
    areYouInterested = data.nightWork == '' ? null : data.nightWork == 'true';

    hasCriminalConvictions = data.criminal == '' ? null : data.criminal == '1';

    if (data.hearAboutUS.isNotEmpty) {
      final index = dropDowns.hearEs
          .indexWhere((element) => element.id == data.hearAboutUS);
      selectedItem = dropDowns.hearEs[index];
    } else {
      selectedItem = dropDowns.hearEs.first;
    }

    if (data.euNational.isNotEmpty) {
      final index = dropDowns.euNational
          .indexWhere((element) => element.id == data.euNational);
      selectedEU = dropDowns.euNational[index];
    } else {
      selectedEU = dropDowns.euNational.first;
    }
    await localStorage?.setString('dob', data.dob);
  }

  Future<String> updateTempInfo() async {
    data.nationalInsuranceYes = 'yes';
    final response = await Services.shared.updateTempInfo(data);
    return response.errorMessage;
  }

  String validate() {
    if (data.dob.isEmpty) {
      return 'validBirthdate'.tr;
    } else if (selectedEU.id.isEmpty) {
      return 'euNS'.tr;
    } else if (!formKey.currentState!.validate()) {
      return 'error'.tr;
    } else if (data.emergencyContactRelationship.isEmpty) {
      return 'emergencyContactRelationship'.tr;
    } else if (selectedItem.id.isEmpty) {
      return 'hearAboutExtraStaffQuestion'.tr;
    } else if (data.criminal.isEmpty) {
      return 'hasCriminalConvictions'.tr;
    }
    return '';
  }

  setDate(DateTime date) => data.dob = dateToString(date);

  DateTime? stringToDate(String dateTime) {
    try {
      return serverDateFormat.parse(dateTime);
    } catch (e) {
      print('Error wrong date');
      return selectedDob;
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
