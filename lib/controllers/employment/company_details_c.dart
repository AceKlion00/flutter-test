import 'package:extra_staff/models/company.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyDetailsController extends GetxController {
  Company company = Company.fromJson({});
  DateTime currentDate = getNow;
  String startDate = '';
  String endDate = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<String> updateTempEmployeeInfo() async {
    final response = await Services.shared.updateTempEmployeeInfo(company);
    return response.errorMessage;
  }

  setDates() {
    if (company.suggestedStartDate.isNotEmpty) {
      startDate = formatDate(stringToDate(company.suggestedStartDate));
    }
    if (company.suggestedEndDate.isNotEmpty) {
      endDate = formatDate(stringToDate(company.suggestedEndDate));
    }
  }

  setStartDate(DateTime date) {
    startDate = formatDate(date);
    company.suggestedStartDate = dateToString(date);
  }

  setEndDate(DateTime date) {
    endDate = formatDate(date);
    company.suggestedEndDate = dateToString(date);
  }

  DateTime stringToDateDob(String dateTime) {
    try {
      return serverDateFormat.parse(dateTime);
    } catch (e) {
      print('Error wrong date');
      return minDate;
    }
  }

  DateTime stringToDate(String dateTime) {
    try {
      return serverDateFormat.parse(dateTime);
    } catch (e) {
      print('Error wrong date');
      return currentDate;
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
