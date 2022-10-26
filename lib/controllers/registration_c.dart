import 'package:extra_staff/models/drop_donws_m.dart';
import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class RegistrationController extends GetxController {
  UserData data = UserData.fromJson({});
  DropDowns dropDowns = DropDowns.fromJson({});
  List<bool> completedValues = [];
  List<String> status = [];

  Future<String> getTempUserData() async {
    await Services.shared.setData();
    final response = await Services.shared.getTempUserData();
    if (response.result is Map) data = UserData.fromJson(response.result);
    if (response.errorMessage.isEmpty) {
      await localStorage?.setString(
          'userName', data.firstName + ' ' + data.lastName);
    }
    return response.errorMessage;
  }

  Future<String> getDropdownInfo() async {
    final response = await Services.shared.getDropdownInfo();
    dropDowns = DropDowns.fromJson(response.result);
    return response.errorMessage;
  }

  Future<String> getTempAgreementInfo() async {
    final response = await Services.shared.getTempAgreementInfo();
    if (response.result is List) {
      for (var i in response.result) {
        if (i is Map) {
          if (i['document_type'] is String) {
            status.add(i['document_type']);
          }
        }
      }
    }
    return response.errorMessage;
  }

  bool onTheFlow(int index) => index == 0 ? true : completedValues[index - 1];

  getCompletedValues() async {
    completedValues.removeWhere((element) => true);
    final keys = [
      'isAboutYouCompleted',
      'isEmploymentHistoryCompleted',
      'isCompetencyTestCompleted',
      'isHMRCCompleted',
      'isAgreementsCompleted',
    ];
    for (var k in keys) {
      completedValues.add(localStorage?.getBool(k) ?? false);
    }
  }
}
