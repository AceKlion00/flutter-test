import 'dart:convert';

import 'package:extra_staff/models/drop_donws_m.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Availability2Controller extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isForklift = false;
  bool? isForkliftDocUploaded;
  bool? areYouInterested;
  bool dMon = false;
  bool dTue = false;
  bool dWed = false;
  bool dThu = false;
  bool dFri = false;
  bool dSat = false;
  bool dSun = false;

  bool hourOutput = false;

  DateTime? selectedDob;
  DateTime? dbsDate;

  bool? haveOwnTransport;
  bool? requireHiVis;
  bool? requireSafetyBoots;

  KeyValue selectedItem = KeyValue.fromJson({});
  UserData data = UserData.fromJson({});
  DropDowns dropDowns = DropDowns.fromJson({});

  final contactRelationship = [
    KeyValue('Family Member', 'Family Member'),
    KeyValue('Friend', 'Friend'),
    KeyValue('Colleague', 'Colleague'),
  ];

  KeyValue selected48Hour = KeyValue('', '');

  final hours48 = [
    KeyValue('1', 'Yes'),
    KeyValue('2', 'No'),
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

  String dateToShow() => data.dbsDate.isNotEmpty ? data.dbsDate : 'dd/mm/yyyy';

  setData() {
    selected48Hour = data.hourOutput == '1' ? hours48.first : hours48.last;
    dMon = data.monday.isNotEmpty && data.monday == 'true' ? true : false;
    dTue = data.tuesday.isNotEmpty && data.tuesday == 'true' ? true : false;
    dWed = data.wednesday.isNotEmpty && data.wednesday == 'true' ? true : false;
    dThu = data.thursday.isNotEmpty && data.thursday == 'true' ? true : false;
    dFri = data.friday.isNotEmpty && data.friday == 'true' ? true : false;
    dSat = data.saturday.isNotEmpty && data.saturday == 'true' ? true : false;
    dSun = data.sunday.isNotEmpty && data.sunday == 'true' ? true : false;
    areYouInterested = data.nightWork == '' ? null : data.nightWork == 'true';

    haveOwnTransport =
        data.ownTrasport == '' ? null : data.ownTrasport == 'true';
    requireHiVis = data.hiVis == '' ? null : data.hiVis == 'true';
    requireSafetyBoots =
        data.requireSafetyBoot == '' ? null : data.requireSafetyBoot == 'true';

    if (data.dbsDate.isNotEmpty) {
      dbsDate = stringToDate(data.dbsDate, true);
    }

    if (data.safetyBootSize.isNotEmpty) {
      final index = dropDowns.safetyBootSize
          .indexWhere((element) => element.id == data.safetyBootSize);
      selectedItem = dropDowns.safetyBootSize[index];
    } else {
      selectedItem = dropDowns.safetyBootSize.first;
    }
  }

  getDataFromStorage() {
    final storedData = localStorage?.getString('RolesView') ?? '';
    final map = json.decode(storedData);
    isForklift = map['isForklift'];
  }

  Future<String> updateTempWorkInfo() async {
    final response = await Services.shared.updateTempWorkInfo(data);
    return response.errorMessage;
  }

  Future apiCalls() async {
    String message = '';
    message = await getTempUserData();
    if (message.isNotEmpty) {
      abShowMessage(message);
    } else {
      await localStorage?.setString(
          'userName', data.firstName + ' ' + data.lastName);
    }
    message = await getSafetyDropdownInfo();
    if (message.isNotEmpty) abShowMessage(message);
  }

  Future<String> getSafetyDropdownInfo() async {
    final response = await Services.shared.getSafetyDropdownInfo();
    dropDowns = DropDowns.fromJson(response.result);
    return response.errorMessage;
  }

  Future<String> getTempUserData() async {
    final response = await Services.shared.getTempUserData();
    if (response.result is Map) {
      data = UserData.fromJson(response.result);
      isQuizTest = data.quizTest == '1';
    }
    return response.errorMessage;
  }

  String validate() {
    if (data.monday.isEmpty &&
        data.tuesday.isEmpty &&
        data.wednesday.isEmpty &&
        data.thursday.isEmpty &&
        data.friday.isEmpty &&
        data.saturday.isEmpty &&
        data.sunday.isEmpty) {
      return 'workDays'.tr;
    } else if (data.nightWork.isEmpty) {
      return 'workingInNightQuestion'.tr;
    } else if (haveOwnTransport == null) {
      return 'ownTransport'.tr;
    } else if (requireHiVis == null) {
      return 'hiVis'.tr;
    } else if (requireSafetyBoots == null) {
      return 'safetyBoots'.tr;
    } else if (requireSafetyBoots == true && selectedItem.id.isEmpty) {
      return 'shoeSize'.tr;
    } else if (isForklift && isForkliftDocUploaded != true) {
      return 'Please upload your Forklift Licence';
    } else if (data.dbsCheck == '1' && data.dbsDate.isEmpty) {
      return 'Please add DBS date.';
    } else {
      return '';
    }
  }
}
