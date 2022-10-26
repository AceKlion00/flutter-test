import 'package:extra_staff/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/models/driving_test_m.dart';

class DrivingTestController extends GetxController {
  final drivingTest = GlobalKey<FormState>();

  DrivingTestModel test = DrivingTestModel.fromJson({});

  String licenseDateApp = '';

  final row1 = [
    '9',
    '9',
    '4.5',
    '15',
    '56',
    '11',
    '15',
    '30',
    '2',
    '45',
  ];

  final row2 = [
    '10',
    '45',
    '90',
    '24',
    '48',
    '6',
    '35',
    '30',
    '45',
    '60',
  ];

  final longTexts = [
    "The numbers needed to complete the following statements in the driver's hours and working time test are all tabled below.",
    'You can drive for a maximum of ＿ hours before you are required to take a break from driving.',
    'When the maximum driving period before a break is required is reached, a break of ＿ minutes must be taken or commence period of rest.',
    'This break may be replaced by a break of at least ＿ minutes followed by a break of at least ＿ minutes providing the driver does not exceed maximum driving time without a break.',
    'You are permitted to drive up to ＿ hours per day normally.',
    'The driver can extend the driving period on no more than ＿ occasions in a week, to a maximum of ＿ hours.',
    'Maximum number of hours that can be driven in a week is ＿ hours but the driver must not exceed ＿ hours in two consecutive weeks.',
    'Break is defined as any period during which the driver may NOT carry out any driving or any other work and which is used exclusively for recuperation',
    'Rest is defined as a period during which the driver may freely dispose of their time. All daily rest must be completed within the 24 hour period which commenced when the driver started duty',
    'A regular daily rest is deemed to be a period of at least ＿ hours.',
    'A reduced daily rest is at least ＿ hours.',
    'In any two consecutive weeks a driver shall take at least:',
    'Two regular rest periods or',
    'One regular weekly rest period and one reduced weekly rest period of at least 24 hours. However, the reduction shall be compensated by an equivalent period of rest taken en bloc before the end of the third week following the week in question and attached to another period of rest of at least 9 hours.',
    'A regular weekly rest is at least ＿ hours and a reduced weekly rest is a minimum of ＿ hours.',
    'A driver is required to complete ＿ hours periodic training every 5 years to obtain a drivers CPC.',
    'Working Time',
    "All drivers of vehicles that are subject to the EC driver's hours rules have to apply the Working Time Regs.",
    "Working Time does not include 'periods of availability' or 'breaks' but does include driving and all other duties",
    'Breaks taken to comply with working time can also satisfy all or part of your requirements to take a break from driving.',
    'A driver must not exceed ＿ hours work without taking a break',
    'The minimum break period is ＿ minutes',
    'A shift of between 6 & 9 hours will require breaks totalling ＿ minutes to be taken.',
    'A shift of over 9 hours will require breaks totalling ＿ minutes to be taken.',
    'The average working time over the reference period must not exceed ＿ hours.',
    'The maximum time that can he worked in any one week is ＿ hours.',
  ];

  bool validated() {
    if (test.licenseDate.isEmpty) {
      abShowMessage('Please enter Licence date.');
    } else if (drivingTest.currentState!.validate()) {
      return true;
    } else {
      abShowMessage('error'.tr);
    }
    return false;
  }

  Future<bool> getTempDrivingTestInfo() async {
    final response = await Services.shared.getTempDrivingTestInfo();
    test.driverName = userName;
    if (response.errorCode == 0 && response.result is Map) {
      test = DrivingTestModel.fromJson(response.result);
      if (test.licenseDate.isNotEmpty) {
        final date = stringToDate(test.licenseDate, true);
        licenseDateApp =
            date != null ? formatDate(date) : dateToString(getNow, false) ?? '';
      }
    }
    if (response.errorMessage.isNotEmpty) {
      abShowMessage(response.errorMessage);
      return false;
    }
    return true;
  }

  Future<bool> updateTempDrivingTestInfo() async {
    final response = await Services.shared.updateTempDrivingTestInfo(test);
    if (response.errorMessage.isEmpty) {
      return true;
    } else {
      abShowMessage(response.errorMessage);
      return false;
    }
  }
}
