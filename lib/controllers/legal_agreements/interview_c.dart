import 'package:extra_staff/models/interview_m.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';

class InterviewController extends GetxController {
  DateTime interviewDate = getNow;
  String interviewDateStr = '';
  InterViewModel dropDowns = InterViewModel.fromJson({});
  KeyValue interviewMethod = KeyValue.fromJson({});
  KeyValue interviewTime = KeyValue.fromJson({});

  Future<String> getQuickTempVerification() async {
    final response = await Services.shared.getInterviewDropdownInfo();
    dropDowns = InterViewModel.fromJson(response.result);
    if (dropDowns.methods.isNotEmpty) {
      interviewMethod = dropDowns.methods.first;
    }
    if (dropDowns.times.isNotEmpty) {
      interviewTime = dropDowns.times.first;
    }
    return response.errorMessage;
  }

  Future<String> updateTempInterviewInfo() async {
    final response = await Services.shared.updateTempInterviewInfo(
        interviewMethod.id, interviewDateStr, interviewTime.id);
    return response.errorMessage;
  }

  setInterviewDate(DateTime date) => interviewDateStr = dateToString(date);

  DateTime stringToDate(String dateTime) {
    try {
      return serverDateFormat.parse(dateTime);
    } catch (e) {
      print('Error wrong date');
      return interviewDate;
    }
  }

  String dateToString(DateTime dateTime) {
    try {
      return formatDate(dateTime);
    } catch (e) {
      print('Error wrong date');
      return serverDateFormat.format(getNow);
    }
  }

  String validate() {
    if (interviewMethod.id.isEmpty) {
      return 'likeInterviewConducted'.tr;
    } else if (interviewTime.id.isEmpty) {
      return 'wtcyd'.tr;
    } else if (interviewDateStr.isEmpty) {
      return 'interviewDate'.tr;
    }
    return '';
  }
}
